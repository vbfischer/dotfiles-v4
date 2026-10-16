local toggle_key = "<C-,>"

-- Inside herdr, open Claude in a sibling herdr pane (nvim keeps its own
-- layout); anywhere else fall back to a snacks terminal split in nvim.
local in_herdr = vim.env.HERDR_ENV == "1"

--- Build the shell script that splits the current herdr pane and runs claude in it.
---@param cmd_string string claude command (already includes args)
---@param env_table table<string, string> env vars claudecode.nvim wants set (SSE port, etc.)
---@return string[]
local function herdr_split_cmd(cmd_string, env_table)
  local exports = {}
  for k, v in pairs(env_table) do
    table.insert(exports, string.format("%s=%s", k, vim.fn.shellescape(v)))
  end
  -- Reuse a claude agent already running in this workspace + cwd; only split when none exists.
  local find_existing = 'existing=$(herdr agent list | jq -r --arg ws "$HERDR_WORKSPACE_ID" --arg cwd "$PWD" '
    .. "'[.result.agents[] | select(.agent == \"claude\" and .workspace_id == $ws and .cwd == $cwd)][0].pane_id // empty')"
  local split_and_run = table.concat({
    'pane=$(herdr pane split --current --direction right --ratio 0.75 --focus --cwd "$PWD" | jq -r ".result.pane.pane_id")',
    string.format('herdr pane run "$pane" %s', vim.fn.shellescape(table.concat(exports, " ") .. " " .. cmd_string)),
  }, " && ")
  local script = find_existing
    .. '; if [ -n "$existing" ]; then herdr agent focus "$existing" >/dev/null; else '
    .. split_and_run
    .. "; fi"
  return { "sh", "-c", script }
end

return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      terminal = in_herdr and {
        provider = "external",
        provider_opts = { external_terminal_cmd = herdr_split_cmd },
      } or {
        provider = "snacks",
        split_side = "right",
        split_width_percentage = 0.4,
      },
    },
    keys = {
      { toggle_key, "<cmd>ClaudeCode<cr>", desc = "Claude Code", mode = { "n", "x" } },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
