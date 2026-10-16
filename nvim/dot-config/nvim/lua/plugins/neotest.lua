return {
    {
        'nvim-neotest/neotest',
        dependencies = { 'nvim-neotest/neotest-jest' },
        opts = {
            adapters = {
                ['neotest-jest'] = {
                    jestCommand = 'pnpm exec jest',
                    cwd = function()
                        return vim.fn.getcwd()
                    end,
                },
            },
        },
    },
}
