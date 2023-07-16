vim.keymap.set("n", "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Current line blame" })
vim.keymap.set("n", "<leader>gL", "<cmd>Gitsigns blame_line<cr>", { desc = "Blame line popup" })
vim.keymap.set({ "o", "x" }, "ih", ":<C-u>Gitsigns select_hunk<cr>", { desc = "Git hunk" })

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "petertriho/cmp-git", dependencies = "nvim-lua/plenary.nvim", opts = { github = { pull_requests = 10 } } },
    },
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.cmp_source_names["git"] = "(git)"

      cmp.setup.filetype({ "gitcommit" }, {
        sources = cmp.config.sources({ { name = "git" } }),
      })

      -- opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
      --   { name = "git", priority = 10 },
      -- }, 1, #opts.sources))
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    init = function()
      vim.g.lazygit_floating_window_winblend = 5
    end,
    cmd = { "LazyGit", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    keys = { { "<leader>gg", "<cmd>LazyGitCurrentFile<cr>", desc = "Lazygit" } },
  },
  {
    "NeogitOrg/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    opts = { disable_commit_confirmation = true, use_telescope = true },
    keys = { { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" } },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewFileHistory", "DiffviewOpen" },
    opts = {
      keymaps = {
        view = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
          {
            "n",
            "co",
            function()
              require("diffview.actions").conflict_choose("ours")
            end,
            { desc = "Choose OURS version of a conflict" },
          },
          {
            "n",
            "ct",
            function()
              require("diffview.actions").conflict_choose("theirs")
            end,
            { desc = "Choose THEIRS version of a conflict" },
          },
          {
            "n",
            "cb",
            function()
              require("diffview.actions").conflict_choose("ours")
            end,
            { desc = "Choose BASE version of a conflict" },
          },
          {
            "n",
            "ca",
            function()
              require("diffview.actions").conflict_choose("ours")
            end,
            { desc = "Choose all versions of a conflict" },
          },
        },
        file_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } } },
      },
    },
    keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview" } },
  },
}
