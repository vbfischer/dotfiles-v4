return {
  {
    "zbirenbaum/copilot.lua",
    optional = true,
    opts = function()
      require("copilot.api").status = require("copilot.status")
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["html"] = { "prettier" },
        ["css"] = { "prettier" },
        ["tsx"] = { "prettier" },
      },
    },
  },
  {
    "yochem/jq-playground.nvim",
    opts = {
      cmd = { "jq" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-live-grep-args.nvim",
      config = function()
        require("telescope").load_extension("live_grep_args")
      end,
    },
  },
  {
    "alexghergh/nvim-tmux-navigation",
    config = true,
    keys = {
      {
        "<C-h>",
        "<cmd>NvimTmuxNavigateLeft<cr>",
        desc = "Navigate Left",
      },
      {
        "<C-j>",
        "<cmd>NvimTmuxNavigateDown<cr>",
        desc = "Navigate Down",
      },
      {
        "<C-k>",
        "<cmd>NvimTmuxNavigateUp<cr>",
        desc = "Navigate Up",
      },
      {
        "<C-l>",
        "<cmd>NvimTmuxNavigateRight<cr>",
        desc = "Navigate Right",
      },
      {
        "<C-\\>",
        "<cmd>NvimTmuxNavigateLastActive<cr>",
        desc = "Navigate Last Active",
      },
      {
        "<C-Space>",
        "<cmd>NvimTmuxNavigateNext<cr>",
        desc = "Navigate Next",
      },
    },
  },
}
