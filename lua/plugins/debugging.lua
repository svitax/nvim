return {
  {
    -- textobject operator for printing/logging statements
    -- TODO: replace printer.nvim with refactoring.nvim functionality
    "rareitems/printer.nvim",
    opts = {
      keymap = "gp",
      formatters = {
        javascriptreact = function(text_inside, text_var)
          return string.format('console.log("%s = ", %s)', text_inside, text_var)
        end,
        typescriptreact = function(text_inside, text_var)
          return string.format('console.log("%s = ", %s)', text_inside, text_var)
        end,
      },
      -- TODO: the filepath in the default add_to_inside will look better if I use vim-rooter
      -- add_to_inside = function(text)
      --   return string.format("[%s:%s] %s", vim.fn.expand("%"), vim.fn.line("."), text)
      -- end,
    },
    keys = { { "gp", desc = "Debug printing operator" } },
  },
}
