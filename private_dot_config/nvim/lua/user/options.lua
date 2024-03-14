local options = {
  backup = false,                          -- creates a backup file
  -- clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
  cmdheight = 2,                           -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0,                        -- so that `` is visible in markdown files
  fileencoding = "utf-8",                  -- the encoding written to a file
  hlsearch = true,                         -- highlight all matches on previous search pattern
  ignorecase = true,                       -- ignore case in search patterns
  mouse = "a",                             -- allow the mouse to be used in neovim
  pumheight = 10,                          -- pop up menu height
  showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
  showtabline = 2,                         -- always show tabs
  smartcase = true,                        -- smart case
  smartindent = true,                      -- make indenting smarter again
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window
  swapfile = false,                        -- creates a swapfile
  termguicolors = true,                    -- set term gui colors (most terminals support this)
  timeoutlen = 1000,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,                         -- enable persistent undo
  updatetime = 300,                        -- faster completion (4000ms default)
  writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,                        -- convert tabs to spaces
  shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  tabstop = 2,                             -- insert 2 spaces for a tab
-- cursorline = true,                       -- highlight the current line
  number = true,                           -- set numbered lines
  relativenumber = false,                  -- set relative numbered lines
  numberwidth = 4,                         -- set number column width to 2 {default 4}
  -- signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
  wrap = true,                            -- display lines as one long line
  scrolloff = 8,                           -- is one of my fav
  sidescrolloff = 8,
  guifont = "monospace:h17",               -- the font used in graphical neovim applications
}

vim.opt.shortmess:append "c"

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.g.buftabline_numbers = 1
vim.g.rblist_levels = 8
vim.g.vimwiki_list = {{path = '~/notes', syntax = 'markdown', diary_rel_path = ''}}
vim.g.slime_python_ipython = 1
vim.g.slime_target = "tmux"
vim.g.slime_dont_ask_default = 1
vim.g.python3_host_prog = "~/.nvim-venv/bin/python" 
-- vim.g.python_host_prog = "/Users/nathanbraun/neovim-python2/bin/python"
vim.g.zettel_default_mappings = 0
-- vim.g.zettel_options = {{template = "~/vimwiki/templates/template.tpl", disable_front_matter = 1}}
vim.wo.colorcolumn = "81"
vim.cmd [[let g:slime_default_config = {"socket_name": "default", "target_pane": ":.2"}]]
vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
vim.cmd [[set formatoptions-=cro]] -- TODO: this doesn't seem to work
vim.cmd [[ set viminfo='800,<50,s10,h,rA:,rB: ]]
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

-- vim.g.copilot_no_tab_map = true
-- vim.api.nvim_set_keymap("i", "<C-N>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

vim.cmd('source ~/.config/nvim/vim/vim-ai-persistent.vim')
vim.g.aichat_yaml_header = "---\ntitle: Untitled\ndate: %date%\ntags: [aichat]\n---"

vim.g.vim_ai_chat = {
  options = {
    model = "gpt-4-1106-preview",
    initial_prompt = [[
>>> system

You are a general assistant.
If you attach a code block add syntax type after ``` to enable syntax highlighting.

The first time your respond as assistant, please give a very brief title (a few words) for the discussion in the format "Proposed Title: Your Title". Only do this once, don't do it if there's a proposed title earlier in the conversation.
    ]]
  }
}
