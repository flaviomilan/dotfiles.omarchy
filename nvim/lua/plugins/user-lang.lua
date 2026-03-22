-- Most languages are configured via LazyVim extras in lua/config/lazy.lua
-- This file contains overrides and languages without an official LazyVim extra.

return {
  -- neotest: Ruby adapters + go guard
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "zidhuss/neotest-minitest",
    },
    opts = {
      output = { open_on_run = false },
      output_panel = { enabled = true, open = "botright split | resize 12" },
      adapters = {
        ["neotest-minitest"] = {
          test_cmd = function()
            -- DISABLE_MINITEST_REPORTERS=1 reverts to standard minitest verbose output,
            -- which neotest-minitest can parse. SpecReporter format breaks result detection.
            return { "env", "DISABLE_MINITEST_REPORTERS=1", "bundle", "exec", "ruby", "-Itest" }
          end,
        },
        ["neotest-rspec"] = {
          rspec_cmd = function()
            return { "bundle", "exec", "rspec" }
          end,
        },
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
