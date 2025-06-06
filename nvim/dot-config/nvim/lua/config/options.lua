-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.shiftwidth = 4
opt.tabstop = 4

opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldenable = true
opt.foldlevel = 99

vim.cmd([[command! -nargs=0 GoToFile :lua Snacks.picker.smart()]])
