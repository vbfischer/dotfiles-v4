-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set('n', '<leader>Ds', function()
    local dir = vim.fn.expand('~/sql-scratch')
    vim.fn.mkdir(dir, 'p')
    vim.cmd('edit ' .. vim.fn.fnameescape(dir .. '/scratch.sql'))
    vim.cmd('DBUIFindBuffer')
end, { desc = 'SQL scratch file' })
