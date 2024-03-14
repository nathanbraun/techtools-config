vim.g.skip_ts_context_commentstring_module = true

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end



configs.setup {
  ensure_installed = {"python"}, -- one of "all", "maintained", or a list of languages
  sync_install = false,
  ignore_install = {},
  autopairs = {
    enable = true,
  },
  highlight = {
    enable = true,
    disable = {}, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = true,
    disable = { "yaml" }
  },
  -- Removed the deprecated context_commentstring configuration from here
}

require('ts_context_commentstring').setup {}
