-- Personal tools and navigation
return {
  -- Oil.nvim: file browser that replaces netrw
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      view_options = { show_hidden = true },
      float = { padding = 2 },
    },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory (Oil)" },
    },
  },

  -- Smart-splits: tmux-aware window navigation
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    keys = {
      { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to left window" },
      { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move to below window" },
      { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to above window" },
      { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right window" },
    },
  },

  -- Ruby on Rails
  {
    "tpope/vim-projectionist",
    lazy = false,
  },
  {
    "tpope/vim-rails",
    -- lazy=false ensures commands like :Emodel/:A are available immediately,
    -- not only after opening a Ruby file for the first time
    lazy = false,
    keys = {
      { "<leader>ra", "<cmd>A<cr>",          desc = "Alternate file (test ↔ source)" },
      { "<leader>rm", "<cmd>Emodel<cr>",     desc = "Edit model" },
      { "<leader>rc", "<cmd>Econtroller<cr>", desc = "Edit controller" },
      { "<leader>rv", "<cmd>Eview<cr>",      desc = "Edit view" },
      { "<leader>rs", "<cmd>Espec<cr>",      desc = "Edit spec" },
      { "<leader>rr", "<cmd>Emigration<cr>", desc = "Edit migration" },
    },
  },
  {
    "tpope/vim-bundler",
    lazy = false,
  },

  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Octo",
    opts = {},
    keys = {
      { "<leader>gi", "<cmd>Octo issue list<cr>", desc = "List issues" },
      { "<leader>gp", "<cmd>Octo pr list<cr>", desc = "List PRs" },
      { "<leader>gr", "<cmd>Octo review start<cr>", desc = "Start review" },
    },
  },
}
