-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Suppress spurious "Command setContext not found" from rubocop-lsp
-- (rubocop sends VS Code-specific commands that Neovim doesn't support)
vim.lsp.handlers["workspace/executeCommand"] = function(err, result, ctx, config)
  if err and type(err.message) == "string" and err.message:find("setContext") then
    return
  end
  -- fallback to default handler
  vim.lsp.handlers["workspace/executeCommand"] = nil
end
