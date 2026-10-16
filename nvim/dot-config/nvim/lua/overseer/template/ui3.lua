-- Dev server for the ui3 React app. Available in any worktree of a repo that has
-- src/main/ui3/package.json at or above the current working directory.
local function find_ui3_dir()
    local dir = vim.fn.getcwd()
    while dir do
        local ui3_dir = dir .. '/src/main/ui3'
        if vim.uv.fs_stat(ui3_dir .. '/package.json') then
            return ui3_dir
        end
        local parent = vim.fs.dirname(dir)
        dir = parent ~= dir and parent or nil
    end
end

return {
    name = 'ui3: dev server',
    desc = 'Start the ui3 Vite dev server (npm run dev)',
    tags = { 'dev' },
    builder = function()
        return {
            cmd = { 'npm', 'run', 'dev' },
            cwd = find_ui3_dir(),
            components = {
                { 'unique', replace = true },
                { 'open_output', on_start = 'always', direction = 'dock', focus = false },
                'default',
            },
        }
    end,
    condition = {
        callback = function()
            return find_ui3_dir() ~= nil
        end,
    },
}
