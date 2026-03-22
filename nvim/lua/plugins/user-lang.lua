-- Most languages are configured via LazyVim extras in lua/config/lazy.lua
-- This file contains overrides and languages without an official LazyVim extra.

return {
  -- neotest: Ruby adapters + go guard
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      -- Minitest adapter (Rails default test framework)
      "zidhuss/neotest-minitest",
    },
    opts = {
      -- Output panel at the bottom instead of floating over the code
      output = { open_on_run = false },
      output_panel = { enabled = true, open = "botright split | resize 12" },
      adapters = {
        -- Minitest: use `bin/rails test` when available, fallback to bundle exec
        ["neotest-minitest"] = {
          test_cmd = function()
            if vim.fn.filereadable("bin/rails") == 1 then
              return { "bin/rails", "test" }
            end
            return { "bundle", "exec", "ruby", "-Itest" }
          end,
        },
        -- RSpec: use bundle exec for projects that use RSpec
        ["neotest-rspec"] = {
          rspec_cmd = function()
            return { "bundle", "exec", "rspec" }
          end,
        },
        -- Disable neotest-golang when `go` is not in PATH
        ["neotest-golang"] = vim.fn.executable("go") == 1 and {} or false,
      },
    },
  },

  -- Bash: no LazyVim extra available
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { bashls = {} } },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "bash-language-server", "shfmt", "shellcheck" },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = { formatters_by_ft = { sh = { "shfmt" }, bash = { "shfmt" } } },
  },
  {
    "mfussenegger/nvim-lint",
    opts = { linters_by_ft = { sh = { "shellcheck" }, bash = { "shellcheck" } } },
  },
}
