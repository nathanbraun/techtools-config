local opts = { noremap = true, silent = true}
local keymap = vim.api.nvim_buf_set_keymap

keymap(0, "n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", opts)
keymap(0, "n", "<leader>zl", "<Cmd>ZkLinks<CR>", opts)
keymap(0, "n", "<leader>zt", "<Cmd>ZkTags<CR>", opts)
keymap(0, "n", "<leader>zi", "<Cmd>ZkIndex<CR>", opts)
-- keymap(0, "x", "zf", ":'<,'>ZkMatch<CR>", opts)
-- keymap(0, "n", "<leader>nf", "<Cmd>ZkNotes { sort = { 'modified' }, match = vim.fn.input('Search text: ') }<CR>", opts)
-- keymap(0, "v", "<leader>nf", "<Cmd>ZkMatch<CR>", opts)

-- new notes
keymap(0, "n", "<leader>zns", '<Cmd>ZkNew { template = "source.md"}<CR>', opts)
keymap(0, "n", "<leader>zna", '<Cmd>ZkNew { template = "atom.md"}<CR>', opts)
keymap(0, "n", "<leader>znm", '<Cmd>ZkNew { template = "molecule.md"}<CR>', opts)
keymap(0, "n", "<leader>znp", '<Cmd>ZkNew { template = "person.md"}<CR>', opts)

keymap(0, "n", "<leader>zn", '<Cmd>ZkNew<CR>', opts)
keymap(0, "v", "<leader>zn", ":'<,'>ZkNewFromTitleSelection<CR>", opts)
keymap(0, "v", "<leader>zc", ":'<,'>ZkNewFromContentSelection<CR>", opts)

keymap(0, "n", "<leader>zo", "<Cmd>ZkNotes<CR>", opts)
-- keymap(0, "n", "<leader>zo", ":ZettelOpen<CR>title: ", opts)
-- keymap(0, "n", "<leader>zf", ":ZettelOpen<CR>", opts)
keymap(0, "n", "T", "<Plug>ZettelYankNameMap", opts)
keymap(0, "n", "<leader>zy", "<Plug>ZettelYankNameMap", opts)
-- keymap(0, "x", "zn", "<Plug>ZettelNewSelectedMap", opts)
-- keymap(0, "x", "no", "<Plug>ZettelTitleSelectedMap<CR>title: ", opts)

local zk = require("zk")
local commands = require("zk.commands")
local ui = require("zk.ui")

function tbl_length(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end   

function get_visual_selection()
    -- this will exit visual mode
    -- use 'gv' to reselect the text
    local _, csrow, cscol, cerow, cecol
    local mode = vim.fn.mode()
    if mode == 'v' or mode == 'V' or mode == '' then
      -- if we are in visual mode use the live position
      _, csrow, cscol, _ = unpack(vim.fn.getpos("."))
      _, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
      if mode == 'V' then
        -- visual line doesn't provide columns
        cscol, cecol = 0, 999
      end
      -- exit visual mode
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<Esc>",
          true, false, true), 'n', true)
    else
      -- otherwise, use the last known visual position
      _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
      _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
    end
    -- swap vars if needed
    if cerow < csrow then csrow, cerow = cerow, csrow end
    if cecol < cscol then cscol, cecol = cecol, cscol end
    local lines = vim.fn.getline(csrow, cerow)
    -- local n = cerow-csrow+1
    local n = tbl_length(lines)
    if n <= 0 then return '' end
    lines[n] = string.sub(lines[n], 1, cecol)
    lines[1] = string.sub(lines[1], cscol)
    return table.concat(lines, "\n")
end

local function yankName(options, picker_options)
  zk.pick_notes(options, picker_options, function(notes)
    local pos = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()

    if picker_options.multi_select == false then
      notes = { notes }
    end
    for _, note in ipairs(notes) do
      local nline = line:sub(0, pos) .. "[" .. note.title  .. "]" .. "(" .. note.path:sub(1,-6) .. ")" .. line:sub(pos + 1)
      vim.api.nvim_set_current_line(nline)
    end
  end)
end


local function yankNameReplace(options, picker_options)
  local selected = get_visual_selection()
  zk.pick_notes(options, picker_options, function(notes)
    local pos = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()

    if picker_options.multi_select == false then
      notes = { notes }
    end
    for _, note in ipairs(notes) do
      local nline = line:sub(0, pos - #selected) .. "[" .. selected  .. "]" .. "(" .. note.path:sub(1,-6) .. ")" .. line:sub(pos + 1)
      vim.api.nvim_set_current_line(nline)
    end
  end)
end

commands.add("ZkYankName", function(options) yankName(options, { title = "Zk Yank" }) end)
commands.add("ZkYankNameReplace", function(options) yankNameReplace(options, { title = "Zk Yank" }) end)

keymap(0, "i", "[[", "<Cmd>ZkYankName<CR>", opts)
keymap(0, "v", "[[", "<Cmd>ZkYankNameReplace<CR>", opts)
