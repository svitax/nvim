-- TODO: {"<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle blame"}
return {
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
        file_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
        },
      },
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview" },
    },
  },
}
