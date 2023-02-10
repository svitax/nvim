return {
  { "rcarriga/nvim-notify", enabled = false },
  { "akinsho/bufferline.nvim", enabled = false },
  { "windwp/nvim-spectre", enabled = false },
  -- { "folke/persistence.nvim", enabled = false },
  { "echasnovski/mini.surround", enabled = false },
  { "echasnovski/mini.surround", enabled = false },
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>fe", false },
      { "<leader>fE", false },
      { "<leader>e", false },
      { "<leader>E", false },
      -- {
      --   "<leader>e",
      --   function()
      --     require("neo-tree.command").execute({ toggle = true, dir = require("lazyvim.util").get_root() })
      --   end,
      --   desc = "Filetree (root dir)",
      -- },
      -- {
      --   "<leader>E",
      --   function()
      --     require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
      --   end,
      --   desc = "Filetree (cwd)",
      -- },
    },
  },
}
