-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Keymap helper function
local map = vim.keymap.set

-- Exit insert mode with 'jk'
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
