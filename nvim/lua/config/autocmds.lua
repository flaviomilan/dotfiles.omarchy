-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Suppress spurious "Command setContext not found" from rubocop-lsp
vim.lsp.handlers["workspace/executeCommand"] = function(err, result, ctx, config)
  if err and type(err.message) == "string" and err.message:find("setContext") then
    return
  end
  vim.lsp.handlers["workspace/executeCommand"] = nil
end

