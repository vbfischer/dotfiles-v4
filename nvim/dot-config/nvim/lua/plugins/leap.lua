-- LazyVim's leap extra maps s/S to <Plug>(leap-forward-to)/(leap-backward-to) via the
-- deprecated add_default_mappings(); those <Plug> names no longer exist in leap.nvim.
return {
    {
        url = 'https://codeberg.org/andyg/leap.nvim.git',
        config = function(_, opts)
            local leap = require('leap')
            for k, v in pairs(opts) do
                leap.opts[k] = v
            end
            vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward)', { desc = 'Leap forward' })
            vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Plug>(leap-backward)', { desc = 'Leap backward' })
            vim.keymap.set({ 'n', 'x', 'o' }, 'gs', '<Plug>(leap-from-window)', { desc = 'Leap from window' })
        end,
    },
}
