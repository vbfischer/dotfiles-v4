return {
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>gB", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame" },
    },
    opts = {
      enabled = true,
      delay = 500,
    },
  },
}
