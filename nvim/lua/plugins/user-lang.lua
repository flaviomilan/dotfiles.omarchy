-- Most languages are configured via LazyVim extras in lua/config/lazy.lua
-- This file contains overrides and languages without an official LazyVim extra.

return {
  -- neotest-rspec: use `bundle exec rspec` so the project's Gemfile rspec is used
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = {
      adapters = {
        ["neotest-rspec"] = {
          rspec_cmd = function()
            return { "bundle", "exec", "rspec" }
          end,
        },
        -- Disable neotest-golang when `go` is not available in PATH
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
