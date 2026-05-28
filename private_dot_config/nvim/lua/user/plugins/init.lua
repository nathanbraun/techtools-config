return { {

  -- My plugins here
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope.nvim",
  "alker0/chezmoi.vim",

  "hiphish/rainbow-delimiters.nvim",
  "gpanders/nvim-parinfer",

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  "JoosepAlviste/nvim-ts-context-commentstring",

  -- mkdnflow
  {
    "jakewvincent/mkdnflow.nvim",
    ft = "markdown",
    config = function()
      local notes_dir = vim.fn.expand("~/notes/")
      require("mkdnflow").setup({
        filetypes = { markdown = true, rmd = true },
        links = { implicit_extension = "md", conceal = true },
        mappings = {
          MkdnTableNextCell = false,
          MkdnTablePrevCell = false,
          MkdnIncreaseHeading = { "n", "-" },
          MkdnDecreaseHeading = { "n", "+" },
        },
        to_do = {
          -- skip the in_progress "[-]" step; toggle cycles [ ] <-> [X]
          status_order = { "not_started", "complete" },
        },
        on_attach = function(bufnr)
          local path = vim.api.nvim_buf_get_name(bufnr)
          if vim.startswith(path, notes_dir) then
            vim.wo.conceallevel = 2
          end
        end,
      })
    end,
  },

  -- render-markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      bullet = {
        enabled = false, -- keep the literal -/*/+ chars
      },
      checkbox = {
        enabled = false, -- keep the literal [ ] / [x] chars
      },
      heading = {
        backgrounds = {}, -- keep the per-level foreground colors, drop the colored bg blocks
        icons = {},       -- no numbered/bullet prefix on headings
      },
      link = {
        enabled = false, -- skip the icon prefix on links
      },
      sign = {
        enabled = false, -- no gutter signs (heading markers in the sign column)
      },
      quote = {
        enabled = false, -- keep the literal `>` char, no styled bar fill
      },
      dash = {
        enabled = false, -- keep literal `---`, no full-width rule
      },
    },
  },

  -- zk
  "zk-org/zk-nvim",

  -- ai chat
  {
    "nathanbraun/nvim-ai",
    config = function()
      require('nai').setup({
        active_provider = "claude_proxy",
        active_model = "sonnet",
        chat_files = {
          directory = "~/notes",
          format = "{id}.md"
        }
      })
    end
  },

  -- math
  'jbyuki/nabla.nvim',

  -- LSP
  'VonHeikemen/lsp-zero.nvim',
  'williamboman/mason.nvim',
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",

  -- cmp plugins
  "hrsh7th/nvim-cmp",    -- The completion plugin

  "hrsh7th/cmp-buffer",  -- buffer completions
  "hrsh7th/cmp-path",    -- path completions
  "hrsh7th/cmp-cmdline", -- cmdline completions
  -- use "saadparwaiz1/cmp_luasnip" -- snippet completions
  "dcampos/cmp-snippy",  -- snippet completions
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-calc",

  -- snippets
  -- use "L3MON4D3/LuaSnip" --snippet engine
  "dcampos/nvim-snippy",
  "rafamadriz/friendly-snippets", -- a bunch of snippets to use

  -- programming
  -- use "github/copilot.vim"
  "jpalardy/vim-slime",

  -- use "wakatime/vim-wakatime"

  "whiteinge/diffconflicts",

  "junegunn/vim-peekaboo",

  "junegunn/fzf",
  "junegunn/fzf.vim",
  "junegunn/vim-easy-align",

  -- Colorschemes
  -- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
  -- use "lunarvim/darkplus.nvim"
  "flazz/vim-colorschemes",

  {
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  "tpope/vim-surround",
  "tpope/vim-commentary",

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  -- essentials
  -- "christoomey/vim-tmux-navigator",
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  "tpope/vim-unimpaired",
  -- "kana/vim-arpeggio",
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup({
        default_mappings = false, -- setting this to false removes all the default mappings
        mappings = {
          -- i for insert
          i = {
            j = {
              k = "<Esc>",
            },
            k = {
              j = "<Esc>",
            },
          },
          c = {
            j = {
              k = "<C-c>",
            },
            k = {
              j = "<C-c>",
            },
          },
          t = {
            j = {
              k = "<C-\\><C-n>",
            },
            k = {
              j = "<C-\\><C-n>",
            },
          },
          v = {
            j = {
              k = "<Esc>",
            },
            k = {
              j = "<Esc>",
            },
          },
          s = {
            j = {
              k = "<Esc>",
            },
            k = {
              j = "<Esc>",
            },
          },
        },
      })
    end,
  },
  "ap/vim-buftabline",
  "mattn/calendar-vim",
  {
    "rlane/pounce.nvim",
    config = function()
      require 'pounce'.setup { accept_keys = "JKNPHLIUOMSDAFGVRBYTCEXWQZ" }
    end
  },
  {
    'smoka7/hop.nvim',
    -- tag = '*', -- optional but strongly recommended
    -- branch = 'v1', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  },
  "airblade/vim-rooter"
  -- "notjedi/nvim-rooter.lua",
} }
