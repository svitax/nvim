OpenTaskBufnr = {}

return {
  {
    "stevearc/overseer.nvim",
    dependencies = { "declancm/windex.nvim", "akinsho/toggleterm.nvim" },
    -- event = "VeryLazy",
    cmd = { "OverseerInfo", "OverseerOpen", "OverseerRun", "OverseerBuild", "OverseerRunCmd", "OverseerToggle" },
    keys = {
      { "<leader>p!", "<cmd>OverseerRunCmd<cr>", desc = "Run cmd in project root" },
      { "<leader>pc", "<cmd>OverseerBuild<cr>", desc = "Compile in project" },
      { "<leader>pr", "<cmd>OverseerRun<cr>", desc = "Run project" },
      { "<leader>pl", "<cmd>OverseerRestartLast<cr>", desc = "Run last task" },
      { "<leader>pp", "<cmd>OverseerToggle<cr>", desc = "Toggle task list" },
      { "<leader>pa", "<cmd>OverseerTaskAction<cr>", desc = "Task action list" },
      { "<leader>pC", "<cmd>OverseerClearCache<cr>", desc = "Clear overseer cache" },
    },
    opts = {
      templates = { "builtin", "rewriter", "user" },
      -- strategy = { "jobstart", preserve_output = true, use_terminal = true },
      strategy = "terminal",
      -- strategy = "toggleterm",
      -- strategy = {
      --   "toggleterm",
      --   use_shell = false,
      --   auto_scroll = false,
      --   close_on_exit = false,
      --   quit_on_exit = "never",
      --   open_on_start = true,
      --   hidden = true,
      --   on_create = function() end,
      -- },
      log = {
        { type = "echo", level = vim.log.levels.WARN },
        { type = "file", filename = "overseer.log", level = vim.log.levels.DEBUG },
      },
      -- task_launcher = { bindings = { n = { ["<leader>pq"] = "Cancel" } } },
      task_list = {
        direction = "right",
        bindings = {
          ["q"] = "<cmd>OverseerToggle<cr>",
          ["<c-;>"] = "<cmd>lua require('windex').switch_window('right')<cr>",
          ["<c-h>"] = "<cmd>lua require('windex').switch_window('right')<cr>",
          ["<c-l>"] = "<cmd>lua require('windex').switch_window('left')<cr>",
          ["gl"] = "IncreaseAllDetail",
          ["g;"] = "DecreaseAllDetail",
          ["{"] = "DecreaseWidth",
          ["}"] = "IncreaseWidth",
          ["["] = "PrevTask",
          ["]"] = "NextTask",
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
    init = function()
      -- This command restarts the most recent Overseer task
      vim.api.nvim_create_user_command("OverseerRestartLast", function()
        local overseer = require("overseer")
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
          vim.notify("No tasks found", vim.log.levels.WARN)
        else
          overseer.run_action(tasks[1], "restart")
        end
      end, {})

      -- The main :Make command from vim-dispatch can be mimicked fairly easily
      -- vim.api.nvim_create_user_command("Make", function(params)
      --   local task = require("overseer").new_task({
      --     cmd = vim.split(vim.o.makeprg, "%s+"),
      --     args = params.fargs,
      --     components = {
      --       { "on_output_quickfix", open = not params.bang, open_height = 8 },
      --       "default",
      --     },
      --   })
      --   task:start()
      -- end, { desc = "", nargs = "*", bang = true })
    end,
    -- config = function(_, opts)
    --   require("overseer").setup(opts)
    --   local has_dap = pcall(require, "dap")
    --   if has_dap then
    --     require("dap.ext.vscode").json_decode = require("overseer.util").decode_json
    --   end
    -- end,
  },
}
