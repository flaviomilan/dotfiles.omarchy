-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- Keep visual selection when indenting
vim.keymap.set("v", ">", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<", "<gv", { desc = "Outdent selection" })

-- Select all content
vim.keymap.set("n", "==", "gg<S-v>G", { desc = "Select all" })
