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
      { "<leader>zl", "<cmd>LBChangeLanguage<cr>", desc = "Change language" },
    },
  },
  {
    "kawre/leetcode.nvim",
    event = "VimEnter",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",
    },
    opts = {
      domain = "com",
      arg = "leetcode.nvim",
      lang = "python3",
      sql = "mysql",
      directory = vim.fn.stdpath("data") .. "/leetcode/",
      logging = true,
      console = { open_on_runcode = false, size = { width = "75%", height = "75%" }, dir = "row" },
      description = { width = "40%" },
    },
  },
  { "folke/which-key.nvim", optional = true, opts = { defaults = { ["<leader>z"] = { name = "+leetcode" } } } },
}
