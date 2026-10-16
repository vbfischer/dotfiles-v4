return {
    {
        'sindrets/diffview.nvim',
        cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
        keys = {
            { '<leader>gvo', '<cmd>DiffviewOpen<cr>', desc = 'Diffview open' },
            { '<leader>gvh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File history (current file)' },
            { '<leader>gvH', '<cmd>DiffviewFileHistory<cr>', desc = 'File history (repo)' },
            { '<leader>gvq', '<cmd>DiffviewClose<cr>', desc = 'Diffview close' },
        },
        opts = {},
    },
}
