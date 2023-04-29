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
}
