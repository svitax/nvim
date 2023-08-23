return {
  {
    "GCBallesteros/NotebookNavigator.nvim",
    dependencies = {
      "echasnovski/mini.comment",
      "echasnovski/mini.ai",
      "Vigemus/iron.nvim",
      -- "anuvyklack/hydra.nvim",
      "smoka7/hydra.nvim",
    },
    keys = {
      {
        "]h",
        function()
          require("notebook-navigator").move_cell("d")
        end,
      },
      {
        "[h",
        function()
          require("notebook-navigator").move_cell("u")
        end,
      },
      { "<leader>meX", "<cmd>lua require('notebook-navigator').run_cell()<cr>", desc = "Run cell" },
      { "<leader>mex", "<cmd>lua require('notebook-navigator').run_and_move()<cr>", desc = "Run cell and move" },
    },
    config = function()
      local nn = require("notebook-navigator")
      local ai = require("mini.ai")
      nn.setup({ activate_hydra_keys = "<leader>meh" })
      ai.setup({ custom_textobjects = { h = nn.miniai_spec } })
    end,
  },
  {
    "Vigemus/iron.nvim",
    main = "iron.core",
    opts = function(_, opts)
      return { config = { repl_open_cmd = require("iron.view").split("40%") } }
    end,
  },
}
