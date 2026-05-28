require('zk_bindings').setup()

-- nvim's built-in markdown ftplugin sets shiftwidth=4; restore the global 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2

-- Conceal scoping: render-markdown.nvim forces conceallevel=3 on every markdown
-- buffer it renders. We only want concealed backticks/link syntax inside ~/notes/;
-- for "real" markdown (e.g. the pandoc book), disable render-markdown for the
-- buffer so conceallevel stays at the global 0 and the raw chars are visible.
-- Deferred via vim.schedule so it runs *after* render-markdown's FileType
-- handler attaches (lazy.nvim re-fires FileType after plugin load).
do
  local notes_dir = vim.fn.expand("~/notes/")
  local path = vim.api.nvim_buf_get_name(0)
  if path ~= "" and not vim.startswith(path, notes_dir) then
    local bufnr = vim.api.nvim_get_current_buf()
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then return end
      pcall(vim.api.nvim_buf_call, bufnr, function()
        vim.cmd("RenderMarkdown buf_disable")
      end)
      for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
        vim.api.nvim_set_option_value("conceallevel", 0, { win = win })
      end
    end)
  end
end

-- gq on a list item: wrap continuation lines to align *after* the bullet.
-- Mirrors what vimwiki did: autoindent on, smart/cindent OFF (they fight the
-- indent that 'n' + formatlistpat tries to apply), 'comments' with fb: for
-- each bullet (checkbox-prefixed variants listed first so they match before
-- the bare bullet), formatoptions tuned for list-aware wrap.
vim.bo.autoindent = true
vim.bo.smartindent = false
vim.bo.cindent = false

-- nvim-treesitter sets indentexpr=nvim_treesitter#indent(), which overrides
-- autoindent — and the 'n' flag in formatoptions needs autoindent to apply
-- its calculated continuation indent. Rather than disable ts indenting (which
-- still does the right thing for typing/<CR>), wrap gq with a brief
-- clear+restore so list-aware wrap works.
local function with_no_indentexpr(fn)
  local saved = vim.bo.indentexpr
  vim.bo.indentexpr = ""
  local ok, err = pcall(fn)
  vim.bo.indentexpr = saved
  if not ok then error(err) end
end

_G.__md_gq_op = function(motion_type)
  with_no_indentexpr(function()
    if motion_type == "line" then
      vim.cmd("silent normal! '[V']gq")
    elseif motion_type == "char" then
      vim.cmd("silent normal! `[v`]gq")
    elseif motion_type == "block" then
      vim.cmd("silent normal! `[\\<C-v>`]gq")
    end
  end)
end

vim.keymap.set("n", "gq", function()
  vim.o.operatorfunc = "v:lua.__md_gq_op"
  return "g@"
end, { buffer = 0, expr = true, desc = "gq with list-aware indent (md)" })

vim.keymap.set("n", "gqq", function()
  vim.o.operatorfunc = "v:lua.__md_gq_op"
  return "g@_"
end, { buffer = 0, expr = true, desc = "gqq with list-aware indent (md)" })

vim.keymap.set("x", "gq", function()
  with_no_indentexpr(function() vim.cmd("normal! gvgq") end)
end, { buffer = 0, desc = "gq with list-aware indent (md)" })

-- vimwiki-style: pressing `o` on a continuation line of a wrapped bullet
-- creates a new bullet below using the parent list item's marker.
-- mkdnflow's default `o` only adds a bullet when the *current* line starts
-- with a marker; on wrapped lines it falls through to a plain `o`.
local function find_parent_list_line(cur_row)
  local ok, mkdnflow = pcall(require, "mkdnflow")
  if not ok or not mkdnflow.lists or not mkdnflow.lists.patterns then return nil end
  local lists = mkdnflow.lists
  local cur_line = vim.api.nvim_buf_get_lines(0, cur_row - 1, cur_row, false)[1]
  if not cur_line or cur_line:match("^%s*$") then return nil end
  local cur_indent = #(cur_line:match("^(%s*)") or "")
  if cur_indent == 0 then return nil end
  for r = cur_row - 1, math.max(1, cur_row - 200), -1 do
    local line = vim.api.nvim_buf_get_lines(0, r - 1, r, false)[1]
    if not line or line:match("^%s*$") then return nil end
    local li_type = lists.hasListType(line)
    if li_type then
      local content_col = #(line:match(lists.patterns[li_type].main) or "")
      if content_col > 0 and cur_indent >= content_col then
        return line
      end
    end
    local line_indent = #(line:match("^(%s*)") or "")
    if line_indent < cur_indent then return nil end
  end
  return nil
end

local function open_continuation(above, fallback)
  local ok, mkdnflow = pcall(require, "mkdnflow")
  if not ok or not mkdnflow.lists then
    vim.api.nvim_feedkeys(fallback, "n", false)
    return
  end
  local cur_line = vim.api.nvim_get_current_line()
  if mkdnflow.lists.hasListType(cur_line) then
    mkdnflow.lists.newListItem(false, above, true, "i", fallback)
    return
  end
  local parent_line = find_parent_list_line(vim.api.nvim_win_get_cursor(0)[1])
  mkdnflow.lists.newListItem(false, above, true, "i", fallback, parent_line)
end

_G.__md_o_continuation = function() open_continuation(false, "o") end
_G.__md_O_continuation = function() open_continuation(true, "O") end

-- mkdnflow registers `o` via its own FileType autocmd that runs after this
-- ftplugin (verified via `:nmap o`). Defer the buffer-local mapping so it
-- wins.
vim.schedule(function()
  if not vim.api.nvim_buf_is_valid(0) or vim.bo.filetype ~= "markdown" then return end
  vim.keymap.set("n", "o", _G.__md_o_continuation,
    { buffer = 0, desc = "New list item below (continuation-aware)" })
  vim.keymap.set("n", "O", _G.__md_O_continuation,
    { buffer = 0, desc = "New list item above (continuation-aware)" })
end)

-- vimwiki-style <CR> on a list line: split at cursor, carry text after the
-- cursor to a new bullet below. mkdnflow ships MkdnNewListItem for this but
-- leaves <CR> unbound. If cmp has an explicitly selected entry, confirm it;
-- otherwise close the popup and run the list logic so mid-bullet <CR> always
-- splits — matches vimwiki, and matches cmp's `select = false` philosophy
-- (auto-shown popups don't steal <CR>).
_G.__md_cr_insert = function()
  local cmp_ok, cmp = pcall(require, "cmp")
  if cmp_ok and cmp.visible() then
    if cmp.get_selected_entry() then
      cmp.confirm()
      return
    end
    cmp.close()
  end
  local line = vim.api.nvim_get_current_line()
  local ok, mkdnflow = pcall(require, "mkdnflow")
  if ok and mkdnflow.lists and mkdnflow.lists.hasListType(line) then
    vim.cmd("MkdnNewListItem")
    return
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", false)
end

vim.keymap.set("i", "<CR>", _G.__md_cr_insert,
  { buffer = 0, desc = "<CR>: confirm cmp, split list item, or newline" })

vim.bo.comments = table.concat({
  "fb:- [ ]", "fb:- [x]", "fb:- [X]", "fb:-",
  "fb:* [ ]", "fb:* [x]", "fb:* [X]", "fb:*",
  "fb:+ [ ]", "fb:+ [x]", "fb:+ [X]", "fb:+",
  "b:>",
}, ",")
vim.opt_local.formatoptions:remove("2")
vim.opt_local.formatoptions:remove("r")
vim.opt_local.formatoptions:remove("o")
vim.opt_local.formatoptions:append("q")
vim.opt_local.formatoptions:append("n")
vim.opt_local.formatoptions:append("c")
vim.opt_local.formatoptions:append("l")
vim.opt_local.formatoptions:append("j")
vim.opt_local.formatlistpat = [[^\s*\(\d\+[.)]\|[-*+]\)\s\+\(\[[ xX]\]\s\+\)\?]]
-- gq's list-aware indent (the 'n' flag) needs a real textwidth to wrap to;
-- with tw=0 it falls back to a path that doesn't apply the list indent.
vim.bo.textwidth = 80

-- Text objects: `il` (inner list item, no children) and `al` (around, with children).
-- Mirrors vimwiki's VimwikiTextObjListSingle (il) / VimwikiTextObjListChildren (al).
local function find_enclosing_list_item(node, row)
  local found
  if node:type() == "list_item" then
    local sr, _, er, ec = node:range()
    local last_line = (ec > 0) and er or (er - 1)
    if sr <= row and row <= last_line then found = node end
  end
  for child in node:iter_children() do
    local deeper = find_enclosing_list_item(child, row)
    if deeper then found = deeper end
  end
  return found
end

local function select_list_item(include_children)
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local ok, parser = pcall(vim.treesitter.get_parser, 0, "markdown")
  if not ok or not parser then return end
  local tree = parser:parse()[1]
  if not tree then return end
  local item = find_enclosing_list_item(tree:root(), row)
  if not item then return end

  local sr, _, er, ec = item:range()
  local last_line = (ec > 0) and er or (er - 1)
  if not include_children then
    -- stop before the first nested `list` child
    for child in item:iter_children() do
      if child:type() == "list" then
        last_line = child:range() - 1
        break
      end
    end
  end
  vim.cmd(("normal! %dGV%dG"):format(sr + 1, last_line + 1))
end

vim.keymap.set({ "o", "x" }, "il", function() select_list_item(false) end,
  { buffer = 0, silent = true, desc = "Text obj: list item (no children)" })
vim.keymap.set({ "o", "x" }, "al", function() select_list_item(true) end,
  { buffer = 0, silent = true, desc = "Text obj: list item (with children)" })

-- gl<char>: convert the bullet style of the current line (or visual range).
-- gL<char>: convert the bullet style of every sibling in the enclosing list.
-- Mirrors vimwiki's VimwikiChangeSymbolTo (line/range) and VimwikiChangeSymbolInListTo (whole list).
local list_marker_types = {
  list_marker_minus = true, list_marker_star = true,
  list_marker_plus  = true, list_marker_dot  = true,
  list_marker_parenthesis = true,
}

local function find_innermost_list(node, row)
  local found
  if node:type() == "list" then
    local sr, _, er, _ = node:range()
    if sr <= row and row < er then found = node end
  end
  for child in node:iter_children() do
    local deeper = find_innermost_list(child, row)
    if deeper then found = deeper end
  end
  return found
end

local function md_tree_root()
  local ok, parser = pcall(vim.treesitter.get_parser, 0, "markdown")
  if not ok or not parser then return nil end
  local tree = parser:parse()[1]
  return tree and tree:root() or nil
end

-- Apply marker edits in reverse order so earlier ranges don't shift later ones.
-- `items` is a list of list_item treesitter nodes ordered by start row.
local function apply_marker_edits(items, new_marker_fn)
  local edits = {}
  for i, item in ipairs(items) do
    for grandchild in item:iter_children() do
      if list_marker_types[grandchild:type()] then
        local sr, sc, _, ec = grandchild:range()
        table.insert(edits, { row = sr, sc = sc, ec = ec, new = new_marker_fn(i) })
      end
    end
  end
  table.sort(edits, function(a, b)
    if a.row == b.row then return a.sc > b.sc end
    return a.row > b.row
  end)
  for _, e in ipairs(edits) do
    vim.api.nvim_buf_set_text(0, e.row, e.sc, e.row, e.ec, { e.new })
  end
end

-- gL<char>: every sibling list_item in the enclosing list at this level.
local function change_bullet_in_list(new_marker_fn)
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local root = md_tree_root()
  if not root then return end
  local list_node = find_innermost_list(root, row)
  if not list_node then return end
  local items = {}
  for child in list_node:iter_children() do
    if child:type() == "list_item" then
      table.insert(items, child)
    end
  end
  apply_marker_edits(items, new_marker_fn)
end

-- gl<char>: every list_item whose start row falls in [line1, line2] (1-based, inclusive).
-- Recurses through nested lists so a visual selection over mixed depths still works.
local function change_bullet_in_range(line1, line2, new_marker_fn)
  local root = md_tree_root()
  if not root then return end
  local items = {}
  local function walk(node)
    if node:type() == "list_item" then
      local sr = node:range()
      if sr + 1 >= line1 and sr + 1 <= line2 then
        table.insert(items, node)
      end
    end
    for child in node:iter_children() do walk(child) end
  end
  walk(root)
  table.sort(items, function(a, b)
    return ({ a:range() })[1] < ({ b:range() })[1]
  end)
  apply_marker_edits(items, new_marker_fn)
end

local function gl_normal(new_marker_fn)
  local row = vim.api.nvim_win_get_cursor(0)[1]
  change_bullet_in_range(row, row, new_marker_fn)
end

local function gl_visual(new_marker_fn)
  local l1, l2 = vim.fn.line("'<"), vim.fn.line("'>")
  if l1 > l2 then l1, l2 = l2, l1 end
  change_bullet_in_range(l1, l2, new_marker_fn)
end

local opts = { buffer = 0, silent = true }
local function bullet(c) return function() return c .. " " end end
local function numbered(i) return i .. ". " end

-- gl<char>: current line / visual range
vim.keymap.set("n", "gl-", function() gl_normal(bullet("-")) end,
  vim.tbl_extend("force", opts, { desc = "List: line → - bullet" }))
vim.keymap.set("n", "gl*", function() gl_normal(bullet("*")) end,
  vim.tbl_extend("force", opts, { desc = "List: line → * bullet" }))
vim.keymap.set("n", "gl+", function() gl_normal(bullet("+")) end,
  vim.tbl_extend("force", opts, { desc = "List: line → + bullet" }))
vim.keymap.set("n", "gl1", function() gl_normal(numbered) end,
  vim.tbl_extend("force", opts, { desc = "List: line → 1. numbered" }))
vim.keymap.set("x", "gl-", function() gl_visual(bullet("-")) end,
  vim.tbl_extend("force", opts, { desc = "List: range → - bullet" }))
vim.keymap.set("x", "gl*", function() gl_visual(bullet("*")) end,
  vim.tbl_extend("force", opts, { desc = "List: range → * bullet" }))
vim.keymap.set("x", "gl+", function() gl_visual(bullet("+")) end,
  vim.tbl_extend("force", opts, { desc = "List: range → + bullet" }))
vim.keymap.set("x", "gl1", function() gl_visual(numbered) end,
  vim.tbl_extend("force", opts, { desc = "List: range → 1. numbered" }))

-- gL<char>: whole enclosing list (all siblings at this level)
vim.keymap.set("n", "gL-", function() change_bullet_in_list(bullet("-")) end,
  vim.tbl_extend("force", opts, { desc = "List: whole list → - bullets" }))
vim.keymap.set("n", "gL*", function() change_bullet_in_list(bullet("*")) end,
  vim.tbl_extend("force", opts, { desc = "List: whole list → * bullets" }))
vim.keymap.set("n", "gL+", function() change_bullet_in_list(bullet("+")) end,
  vim.tbl_extend("force", opts, { desc = "List: whole list → + bullets" }))
vim.keymap.set("n", "gL1", function() change_bullet_in_list(numbered) end,
  vim.tbl_extend("force", opts, { desc = "List: whole list → 1. numbered" }))

vim.keymap.set("n", "<leader>zcu", function()
  local view = vim.fn.winsaveview()
  vim.cmd([[silent! keeppatterns %s/\v^(\s*(\d+[.)]|[-*+])\s+)\zs\[[xX]\]/[ ]/g]])
  vim.fn.winrestview(view)
end, vim.tbl_extend("force", opts, { desc = "Checkboxes: uncheck all in buffer" }))
