return {
  {
    "Dhanus3133/LeetBuddy.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>zf", "<cmd>LBQuestions<cr>", desc = "List Questions" },
      { "<leader>zk", "<cmd>LBQuestion<cr>", desc = "View Question" },
      { "<leader>zr", "<cmd>LBReset<cr>", desc = "Reset Code" },
      { "<leader>zt", "<cmd>LBTest<cr>", desc = "Run Code" },
      { "<leader>zs", "<cmd>LBSubmit<cr>", desc = "Submit Code" },
      { "<leader>zs", "<cmd>LBChangeLanguage<cr>", desc = "Change language" },
    },
  },
  { "folke/which-key.nvim", optional = true, opts = { defaults = { ["<leader>z"] = { name = "+leetcode" } } } },
}
