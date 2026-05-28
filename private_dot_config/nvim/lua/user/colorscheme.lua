vim.cmd [[
try
  colorscheme jellybeans
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]

local function set_markdown_hl()
  vim.api.nvim_set_hl(0, "@markup.italic", { italic = true })
  vim.api.nvim_set_hl(0, "@markup.strong", { bold = true })
  vim.api.nvim_set_hl(0, "@markup.strikethrough", { strikethrough = true })
  vim.api.nvim_set_hl(0, "@markup.link",       { fg = "#8fbfdc", underline = true })
  vim.api.nvim_set_hl(0, "@markup.link.label", { fg = "#8fbfdc", underline = true })
  vim.api.nvim_set_hl(0, "@markup.link.url",   { fg = "#8fbfdc", underline = true })
end

vim.api.nvim_create_autocmd({ "ColorScheme", "FileType" }, {
  callback = set_markdown_hl,
})
set_markdown_hl()
