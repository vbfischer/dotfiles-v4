return {
    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        keys = {
            { '<leader>m', '<cmd>TSJToggle<cr>', desc = 'Split/join node' },
        },
        opts = { use_default_keymaps = false },
    },
}
