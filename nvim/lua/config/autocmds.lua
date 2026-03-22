-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Suppress spurious "Command setContext not found" from rubocop-lsp
vim.lsp.handlers["workspace/executeCommand"] = function(err, result, ctx, config)
  if err and type(err.message) == "string" and err.message:find("setContext") then
    return
  end
  vim.lsp.handlers["workspace/executeCommand"] = nil
end

-- Patch neotest-minitest: set cwd to the Gemfile root so tests always run
-- from the correct Rails project root, regardless of where Neovim was opened.
-- neotest uses vim.fn.getcwd() when spec.cwd is nil, which breaks bundle exec
-- if Neovim was not opened from inside the Rails project directory.
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  once = true,
  callback = function()
    local ok, minitest = pcall(require, "neotest-minitest")
    if not ok then return end

    local orig = minitest.build_spec
    minitest.build_spec = function(args)
      local spec = orig(args)
      if spec then
        local pos_path = args.tree:data().path
        local search_dir = vim.fn.isdirectory(pos_path) == 1
          and pos_path
          or vim.fn.fnamemodify(pos_path, ":h")
        local gemfile = vim.fn.findfile("Gemfile", search_dir .. ";")
        if gemfile ~= "" then
          spec.cwd = vim.fn.fnamemodify(gemfile, ":h")
        end
      end
      return spec
    end
  end,
})
