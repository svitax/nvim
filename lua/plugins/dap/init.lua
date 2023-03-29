return {
  {

    "mfussenegger/nvim-dap",
    dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
      "rcarriga/nvim-dap-ui",
      "mxsdev/nvim-dap-vscode-js",
      "theHamsta/nvim-dap-virtual-text",
      "jbyuki/one-small-step-for-vimkind",
      {
        "mfussenegger/nvim-dap-python",
        opts = { include_configs = true, console = "internalConsole" },
        config = function(_, opts)
          require("dap-python").setup("~/.virtualenvs/debugpy/bin/python", opts)
        end,
      },
    },
    keys = { { "<leader>d" } },
    config = function()
      local adapters = require("plugins.dap.adapters")
      local configurations = require("plugins.dap.configs")

      local mason_dap = require("mason-nvim-dap")
      local dap = require("dap")
      local ui = require("dapui")
      local vt = require("nvim-dap-virtual-text")

      dap.set_log_level("TRACE")

      mason_dap.setup({ ensure_installed = { "node2", "js", "python" } })

      adapters.setup(dap)
      configurations.setup(dap)

      -- ╭──────────────────────────────────────────────────────────╮
      -- │ Keybindings + UI                                         │
      -- ╰──────────────────────────────────────────────────────────╯
      local dap_icons = require("shared").dap_icons
      local diagnostic_icons = require("shared").diagnostic_icons
      vim.fn.sign_define("DapBreakpoint", { text = dap_icons.breakpoint, texthl = "DiagnosticHint" })
      vim.fn.sign_define("DapBreakpointCondition", { text = diagnostic_icons.bold_question, texthl = "DiagnosticHint" })
      vim.fn.sign_define("DapLogPoint", { text = dap_icons.log_point, texthl = "DiagnosticHint" })
      vim.fn.sign_define("DapStopped", { text = dap_icons.stopped, texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapBreakpointRejected", { text = diagnostic_icons.bold_error, texthl = "DiagnosticError" })

      local function dap_start_debugging()
        dap.continue({})
        vim.cmd("tabedit %")
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>", false, true, true), "n", false)
        ui.toggle({})
      end

      vim.keymap.set("n", "<leader>ds", dap_start_debugging, { desc = "Start debugging" })
      vim.keymap.set("n", "<leader>dl", require("dap.ui.widgets").hover, { desc = "Hover" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step out" })
      -- vim.keymap.set("n", "<leader>dL", "<cmd>Telescope dap list_breakpoints<cr>", { desc = "List breakpoints" })

      local function dap_clear_breakpoints()
        dap.clear_breakpoints()
        vim.notify("Breakpoints cleared")
      end

      vim.keymap.set("n", "<leader>dC", dap_clear_breakpoints, { desc = "Clear breakpoints" })

      local function dap_end_debug()
        dap.clear_breakpoints()
        ui.toggle({})
        dap.terminate({}, { terminateDebuggee = true }, function()
          vim.cmd.tabclose()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
          vim.notify("Debugger session ended")
        end)
      end

      vim.keymap.set("n", "<leader>de", dap_end_debug, { desc = "End debug" })

      -- Python adapter
      require("dap-python")

      -- UI Settings
      vt.setup()
      ui.setup({
        icons = { expanded = "▾", collapsed = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          { elements = { "scopes" }, size = 0.3, position = "right" },
          { elements = { "repl", "breakpoints" }, size = 0.3, position = "bottom" },
        },
        floating = { border = "single", mappings = { close = { "q", "<Esc>" } } },
        windows = { indent = 1 },
        render = { max_type_length = nil },
      })
    end,
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = { "mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("dap")
    end,
    keys = {
      { "<leader>dM", "<cmd>Telescope dap commands<cr>", desc = "List commands" },
      { "<leader>dG", "<cmd>Telescope dap configurations<cr>", desc = "List configurations" },
      { "<leader>dV", "<cmd>Telescope dap variables<cr>", desc = "List variables" },
      { "<leader>dF", "<cmd>Telescope dap frames<cr>", desc = "List frames" },
      { "<leader>dL", "<cmd>Telescope dap list_breakpoints<cr>", desc = "List breakpoints" },
    },
  },
}
