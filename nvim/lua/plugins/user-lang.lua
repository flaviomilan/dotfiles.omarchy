-- Language support via LazyVim extras + manual configs
return {
  -- Python: pyright LSP, ruff linter/formatter, black
  { import = "lazyvim.plugins.extras.lang.python" },

  -- TypeScript/JavaScript: ts_ls, prettier
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- Java: jdtls
  { import = "lazyvim.plugins.extras.lang.java" },

  -- Ruby: ruby-lsp, rubocop
  { import = "lazyvim.plugins.extras.lang.ruby" },

  -- Rust: rust-analyzer, rustfmt
  { import = "lazyvim.plugins.extras.lang.rust" },

  -- Go: gopls, goimports, gofmt
  { import = "lazyvim.plugins.extras.lang.go" },

  -- Bash: bash-language-server, shfmt, shellcheck
  { import = "lazyvim.plugins.extras.lang.bash" },

  -- Kotlin: no official LazyVim extra — configure manually
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kotlin_language_server = {},
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "kotlin-language-server",
        "ktlint",
      },
    },
  },
}
