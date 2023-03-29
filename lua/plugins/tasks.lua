return {
  {
    "stevearc/overseer.nvim",
    dependencies = { "declancm/windex.nvim", "akinsho/toggleterm.nvim" },
    opts = {
      templates = { "builtin", "rewriter", "user" },
      -- strategy = { "toggleterm", use_shell = false, close_on_exit = false, open_on_start = true, hidden = true },
      log = {
        { type = "echo", level = vim.log.levels.WARN },
        { type = "file", filename = "overseer.log", level = vim.log.levels.DEBUG },
      },
      task_list = {
        direction = "right",
        bindings = {
          ["q"] = "<cmd>OverseerToggle<cr>",
          ["<c-;>"] = "<cmd>lua require('windex').switch_window('right')<cr>",
          ["<c-l>"] = "<cmd>lua require('windex').switch_window('left')<cr>",
        },
      },
      component_aliases = {
        default = {
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          { "on_complete_notify", system = "unfocused" },
          "on_complete_dispose",
        },
        default_neotest = {
          "on_output_summarize",
          "on_exit_set_status",
          { "on_complete_notify", system = "unfocused" },
          "on_complete_dispose",
          "unique",
          "display_duration",
        },
      },
    },
    cmd = { "OverseerInfo", "OverseerOpen", "OverseerRun", "OverseerBuild", "OverseerRunCmd", "OverseerToggle" },
    keys = {
      { "<leader>p!", "<cmd>OverseerRunCmd<cr>", desc = "Run cmd in project root" },
      { "<leader>pc", "<cmd>OverseerBuild<cr>", desc = "Compile in project" },
      { "<leader>pr", "<cmd>OverseerRun<cr>", desc = "Run project" },
      { "<leader>pp", "<cmd>OverseerToggle<cr>", desc = "Toggle task list" },
      { "<leader>pa", "<cmd>OverseerTaskAction<cr>", desc = "Task action list" },
      { "<leader>pC", "<cmd>OverseerClearCache<cr>", desc = "Clear overseer cache" },
    },
  },
}
