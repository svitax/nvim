return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mxsdev/nvim-dap-vscode-js",
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
      {
        "jbyuki/one-small-step-for-vimkind",
        keys = {
          -- stylua: ignore
          { "<leader>daL", function() require("osv").launch({ port = 8086 }) end, desc = "Adapter Lua Server" },
          -- stylua: ignore
          { "<leader>dal", function() require("osv").run_this() end, desc = "Adapter Lua" },
        },
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          -- Makes a best effort to setup the various debuggers with
          -- reasonable debug configurations
          automatic_installation = true,
          -- You can provide additional configuration to the handlers,
          -- see mason-nvim-dap README for more information
          handlers = {},
          -- You'll need to check that you have the required things installed
          -- online, please don't ask me how to install them :)
          ensure_installed = {
            -- Update this to ensure that you have the debuggers for the langs you want
          },
        },
      },
      {
        "rcarriga/nvim-dap-ui",
        keys = {
          {
            "<leader>du",
            function()
              require("dapui").toggle({})
            end,
            desc = "Toggle Dap UI",
          },
          {
            "<leader>dE",
            function()
              require("dapui").eval({})
            end,
            desc = "Dap eval",
            mode = { "n", "v" },
          },
        },
      },

      {
        "folke/which-key.nvim",
        optional = true,
        opts = {
          defaults = {
            ["<leader>d"] = { name = "+debug" },
            ["<leader>da"] = { name = "+adapters" },
          },
        },
      },
      -- { "LiadOz/nvim-dap-repl-highlights", config = true },
      -- { "Weissle/persistent-breakpoints.nvim", opts = { load_breakpoints_event = { "BufReadPost" } } },
    },
    -- event = "VeryLazy",
    keys = { { "<leader>d" } },
    config = function()
      local adapters = require("plugins.dap.adapters")
      local configurations = require("plugins.dap.configs")

      local mason_dap = require("mason-nvim-dap")
      local dap = require("dap")
      local ui = require("dapui")

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
      local function dap_clear_breakpoints()
        dap.clear_breakpoints()
        vim.notify("Breakpoints cleared")
      end
      local function dap_end_debug()
        dap.clear_breakpoints()
        ui.toggle({})
        dap.terminate({}, { terminateDebuggee = true }, function()
          vim.cmd.tabclose()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
          vim.notify("Debugger session ended")
        end)
      end

      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Breakpoint condition" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to cursor" })
      vim.keymap.set("n", "<leader>de", dap_end_debug, { desc = "End debug" })
      vim.keymap.set("n", "<leader>dg", dap.goto_, { desc = "Go to line (no execute)" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<leader>dj", dap.down, { desc = "Down" })
      vim.keymap.set("n", "<leader>dk", dap.up, { desc = "Up" })
      vim.keymap.set("n", "<leader>dK", require("dap.ui.widgets").hover, { desc = "Hover/Widgets" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run last" })
      vim.keymap.set("n", "<leader>dL", dap_clear_breakpoints, { desc = "Clear breakpoints" })
      vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step out" })
      vim.keymap.set("n", "<leader>dO", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<leader>dp", dap.pause, { desc = "Pause" })
      vim.keymap.set("n", "<leader>dp", dap.repl.toggle, { desc = "Toggle REPL" })
      vim.keymap.set("n", "<leader>ds", dap_start_debugging, { desc = "Start debugging" })
      vim.keymap.set("n", "<leader>dS", dap.session, { desc = "Session" })
      vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })

      -- vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "Step over" })

      -- Python adapter
      require("dap-python")

      -- UI Settings
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
      { "<leader>df", "<cmd>Telescope dap list_breakpoints<cr>", desc = "List breakpoints" },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "rcarriga/cmp-dap" },
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.cmp_source_names["dap"] = "(dap)"

      cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = cmp.config.sources({ { name = "dap" } }),
      })

      -- needed for cmp_dap
      opts.enabled = function()
        return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
      end
    end,
  },
  {
    "ofirgall/goto-breakpoints.nvim",
    dependencies = { "mfussenegger/nvim-dap" },
    keys = {
      { "]D", "<cmd>lua require('goto-breakpoints').next()<cr>", desc = "Next breakpoint" },
      { "[S", "<cmd>lua require('goto-breakpoints').prev()<cr>", desc = "Prev breakpoint" },
      { "]S", "<cmd>lua require('goto-breakpoints').stopped()<cr>", desc = "Dap stopped" },
    },
  },
}
