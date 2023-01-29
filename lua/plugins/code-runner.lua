return {
  {
    "stevearc/overseer.nvim",
    dependencies = { "declancm/windex.nvim" },
    opts = {
      task_list = {
        bindings = {
          ["q"] = "<cmd>OverseerToggle<cr>",
          ["<c-h>"] = "<cmd>lua require('windex').switch_window('right')<cr>",
          ["<c-l>"] = "<cmd>lua require('windex').switch_window('left')<cr>",
        },
      },
    },
    keys = {
      { "<leader>p!", "<cmd>OverseerRunCmd<cr>", desc = "Run cmd in project root" },
      { "<leader>pc", "<cmd>OverseerBuild<cr>", desc = "Compile in project" },
      { "<leader>pr", "<cmd>OverseerRun<cr>", desc = "Run project" },
      { "<leader>pp", "<cmd>OverseerToggle<cr>", desc = "Toggle task list" },
    },
  },
}
