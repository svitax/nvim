-- Todo:
-- * Bug: Running tests on directory doesn't work if directory not in tree (but tree has subdirectories)
-- * Bug: No output or debug info if test fails to run (e.g. try running tests in cpython)
-- * Bug: Sometimes issues with running python tests (dir position stuck in running state)
-- * Bug: Files shouldn't appear in summary if they contain no tests (e.g. python file named 'test_*.py')
-- * Bug: dir/file/namespace status should be set by children
-- * Bug: Run last test doesn't work with marked tests (if ran all marked last)
-- * Feat: If summary tree only has a single (file/dir) child, merge the display
-- * Feat: Different bindings for expand/collapse
-- * Feat: Can collapse tree on a child node
-- * Feat: Can't rerun failed tests
-- * Feat: Configure adapters & discovery on a per-directory basis
-- Investigate:
-- * Does neotest have ability to throttle groups of individual test runs?
-- * Tangential, but also check out https://github.com/andythigpen/nvim-coverage
local icons = require("shared").diagnostic_icons
return {
  { "folke/which-key.nvim", optional = true, opts = { defaults = { ["<leader>b"] = { name = "+buffer" } } } },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "haydenmeade/neotest-jest",
      "stevearc/overseer.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>tn",
        function()
          require("neotest").run.run({})
        end,
        mode = "n",
        desc = "Run nearest test",
      },
      {
        "<leader>tt",
        function()
          require("neotest").run.run({ vim.api.nvim_buf_get_name(0) })
        end,
        mode = "n",
        desc = "Test file",
      },
      {
        "<leader>ta",
        function()
          for _, adapter_id in ipairs(require("neotest").run.adapters()) do
            require("neotest").run.run({ suite = true, adapter = adapter_id })
          end
        end,
        mode = "n",
        desc = "Attach adapter",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        mode = "n",
        desc = "Run last test",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        mode = "n",
        desc = "Debug test",
      },
      {
        "<leader>tp",
        function()
          require("neotest").summary.toggle()
        end,
        mode = "n",
        desc = "Toggle test summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ short = true })
        end,
        mode = "n",
        desc = "Open test output",
      },
    },
    config = function()
      local neotest = require("neotest")
      -- require("neotest.logging"):set_level("trace")
      neotest.setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
          }),
          require("neotest-plenary"),
          require("neotest-jest")({
            cwd = require("neotest-jest").root,
          }),
        },
        discovery = {
          enabled = false,
        },
        -- TODO: do I really want to see neotest runs in my overseer task list?
        consumers = {
          overseer = require("neotest.consumers.overseer"),
        },
        summary = {
          mappings = {
            attach = "a",
            expand = "l",
            expand_all = "L",
            jumpto = "gf",
            output = "o",
            run = "<C-r>",
            short = "p",
            stop = "u",
          },
        },
        icons = {
          passed = icons.check .. " ",
          running = icons.bold_open .. " ",
          failed = icons.error .. " ",
          unknown = icons.question .. " ",
          running_animated = vim.tbl_map(function(s)
            return s .. " "
          end, { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }),
        },
        diagnostic = {
          enabled = true,
        },
        output = {
          enabled = true,
          open_on_run = false,
        },
        status = {
          enabled = true,
          signs = false,
          virtual_text = true,
        },
        quickfix = {
          open = false,
        },
      })
      vim.keymap.set("n", "<leader>tn", function()
        neotest.run.run({})
      end, { desc = "Run nearest test" })
      vim.keymap.set("n", "<leader>tt", function()
        neotest.run.run({ vim.api.nvim_buf_get_name(0) })
      end, { desc = "Test file" })
      vim.keymap.set("n", "<leader>ta", function()
        for _, adapter_id in ipairs(neotest.run.adapters()) do
          neotest.run.run({ suite = true, adapter = adapter_id })
        end
      end, { desc = "Attach adapter" })
      vim.keymap.set("n", "<leader>tl", function()
        neotest.run.run_last()
      end, { desc = "Run last test" })
      vim.keymap.set("n", "<leader>td", function()
        neotest.run.run({ strategy = "dap" })
      end, { desc = "Debug test" })
      vim.keymap.set("n", "<leader>tp", function()
        neotest.summary.toggle()
      end, { desc = "Toggle test summary" })
      vim.keymap.set("n", "<leader>to", function()
        neotest.output.open({ short = true })
      end, { desc = "Open test output" })
      -- TODO: extract the mapping to after/ftplugin/neotest-output.lua and neotest-summary.lua
      -- vim.api.nvim_create_autocmd({ "FileType" }, {
      --   group = vim.api.nvim_create_augroup("NeotestCloseMappings", { clear = true }),
      --   pattern = { "neotest-output", "neotest-summary" },
      --   callback = function()
      --     vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
      --   end,
      -- })
    end,
  },
}
