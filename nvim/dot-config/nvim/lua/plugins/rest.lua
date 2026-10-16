return {
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
      local http_root = vim.fn.expand("~/dotfiles-v4/http")
      -- Load the .env that sits next to a saved request, so each project folder gets its own env
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("rest_saved_requests_env", { clear = true }),
        pattern = http_root .. "/*/*.http",
        callback = function(args)
          local env_file = vim.fs.dirname(args.file) .. "/.env"
          if vim.uv.fs_stat(env_file) then
            require("lazy").load({ plugins = { "rest.nvim" } })
            vim.cmd("Rest env set " .. vim.fn.fnameescape(env_file))
          end
        end,
      })
    end,
    keys = {
      {
        "<leader>rf",
        function()
          Snacks.picker.files({ cwd = vim.fn.expand("~/dotfiles-v4/http"), ft = "http" })
        end,
        desc = "Find saved HTTP request",
      },
      {
        "<leader>rg",
        function()
          Snacks.picker.grep({ cwd = vim.fn.expand("~/dotfiles-v4/http") })
        end,
        desc = "Grep saved HTTP requests",
      },
      { "<leader>r", group = "rest", ft = "http" },
      { "<leader>rr", "<cmd>Rest run<cr>", ft = "http", desc = "Run request" },
      { "<leader>rl", "<cmd>Rest run last<cr>", ft = "http", desc = "Run last request" },
      { "<leader>re", "<cmd>Rest env select<cr>", ft = "http", desc = "Select env" },
      {
        "<leader>rE",
        "<cmd>Rest env set ~/dotfiles-v4/http/vcp-opi-ordering/.env<cr>",
        ft = "http",
        desc = "Set vcp-opi-ordering env",
      },
      { "<leader>ro","<cmd>Rest open<cr>", ft = "http", desc = "Open result pane" },
      { "<leader>rL", "<cmd>Rest logs<cr>", ft = "http", desc = "Open logs" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "http")
    end,
  },
}
