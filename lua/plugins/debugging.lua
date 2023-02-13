return {
  -- operator for printing/logging statements
  {
    "andrewferrier/debugprint.nvim",
    cmd = { "DeleteDebugPrints" },
    opts = { create_keymaps = false },
    keys = {
      {
        "gp",
        function()
          return require("debugprint").debugprint({ motion = true })
        end,
        mode = { "n", "o" },
        expr = true,
        desc = "Debugprint operator",
      },
      {
        "gp",
        function()
          return require("debugprint").debugprint({ variable = true })
        end,
        mode = { "v" },
        expr = true,
        desc = "Debugprint selection",
      },
    },
  },
  -- {
  --   -- TODO: replace printer.nvim with refactoring.nvim functionality
  --   "rareitems/printer.nvim",
  --   opts = {
  --     keymap = "gp",
  --     formatters = {
  --       javascriptreact = function(text_inside, text_var)
  --         return string.format('console.log("%s = ", %s)', text_inside, text_var)
  --       end,
  --       typescriptreact = function(text_inside, text_var)
  --         return string.format('console.log("%s = ", %s)', text_inside, text_var)
  --       end,
  --     },
  --     -- TODO: the filepath in the default add_to_inside will look better if I use vim-rooter
  --     -- add_to_inside = function(text)
  --     --   return string.format("[%s:%s] %s", vim.fn.expand("%"), vim.fn.line("."), text)
  --     -- end,
  --   },
  --   keys = { { "gp", desc = "Debug printing operator" } },
  -- },
}
