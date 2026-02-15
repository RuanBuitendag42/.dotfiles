-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃  未来侍  ·  Editor Visual Options      ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

-- Line numbers
vim.opt.relativenumber = true -- Relative line numbers (essential for vim motions)
vim.opt.number = true -- Show current line number

-- Cursor & scrolling
vim.opt.scrolloff = 8 -- Keep 8 lines visible above/below cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns visible left/right
vim.opt.cursorline = true -- Highlight current line

-- Visual guides
vim.opt.colorcolumn = "80,120" -- Column guides for line length
vim.opt.wrap = false -- Don't wrap long lines
vim.opt.showmode = false -- Mode shown in lualine instead

-- Window appearance
vim.opt.winblend = 10 -- Slight transparency on floating windows
vim.opt.pumblend = 10 -- Slight transparency on popup menu
vim.opt.termguicolors = true -- Full color support

-- Indentation visibility
vim.opt.list = true -- Show whitespace characters
vim.opt.listchars = {
  tab = "▸ ",
  trail = "·",
  nbsp = "␣",
  extends = "❯",
  precedes = "❮",
}

-- Fill characters for cleaner UI
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ", -- Hide ~ on empty lines
}

