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
        -- Minitest: patch build_spec to always run from Gemfile root,
        -- regardless of where Neovim was opened from
        ["neotest-minitest"] = {
          test_cmd = function()
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
    config = function(_, opts)
      -- Patch neotest-minitest: set cwd to the Gemfile root so tests work
      -- regardless of where Neovim was opened (neotest defaults cwd=nil to vim.fn.getcwd())
      local ok, minitest = pcall(require, "neotest-minitest")
      if ok then
        local orig_build_spec = minitest.Adapter.build_spec
        minitest.Adapter.build_spec = function(args)
          local spec = orig_build_spec(args)
          if spec then
            local pos_path = args.tree:data().path
            local search_dir = vim.fn.isdirectory(pos_path) == 1
              and pos_path
              or vim.fn.fnamemodify(pos_path, ":h")
            -- Walk up to find the Gemfile root
            local gemfile = vim.fn.findfile("Gemfile", search_dir .. ";")
            if gemfile ~= "" then
              spec.cwd = vim.fn.fnamemodify(gemfile, ":h")
            end
          end
          return spec
        end
      end

      -- Build adapters table (LazyVim test.core config expects this format)
      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters) do
          if type(name) == "number" then
            if type(config) == "string" then config = require(config) end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then adapter.setup(config)
              elseif adapter.adapter then adapter.adapter(config); adapter = adapter.adapter
              elseif meta and meta.__call then adapter = adapter(config)
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end
      require("neotest").setup(opts)
    end,
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
