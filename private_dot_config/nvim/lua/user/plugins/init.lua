return {{

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

  -- vimwiki
  {"vimwiki/vimwiki", branch = "dev"},

  -- zk
  "zk-org/zk-nvim",

  { "nathanbraun/vim-rainbow-lists", ft = "vimwiki" },

  -- chat gpt
  { "nathanbraun/vim-ai" },

  -- math
  'jbyuki/nabla.nvim',

  -- LSP
  -- Mason for managing LSP servers, formatters, etc.
  {
    'williamboman/mason.nvim',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
    },
  },

  -- cmp plugins 
  "hrsh7th/nvim-cmp",  -- The completion plugin

   "hrsh7th/cmp-buffer",  -- buffer completions
   "hrsh7th/cmp-path",  -- path completions
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
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  "tpope/vim-unimpaired",
  "kana/vim-arpeggio",
  "ap/vim-buftabline",
  "mattn/calendar-vim",
  { "rlane/pounce.nvim",
    config = function()
      require'pounce'.setup { accept_keys = "JKNPHLIUOMSDAFGVRBYTCEXWQZ" }
    end
  },
  {
    'smoka7/hop.nvim',
    -- tag = '*', -- optional but strongly recommended
    branch = 'v1', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  },
  "airblade/vim-rooter"
  -- "notjedi/nvim-rooter.lua",
}}

