local get_input = function(prompt)
  local ok, input = pcall(vim.fn.input, string.format("%s: ", prompt))
  if not ok then
    return
  end
  return input
end

local surround = require("nvim-surround")
surround.buffer_setup({
  surrounds = {
    l = { add = { "function () ", " end" } },
    F = {
      add = function()
        return { { string.format("local function %s() ", get_input("Enter a func name")) }, { " end" } }
      end,
    },
    i = {
      add = function()
        return { { string.format("if %s then ", get_input("Enter a condition")) }, { " end" } }
      end,
    },
    t = {
      add = function()
        return { { string.format("{ %s = { ", get_input("Enter a field name")) }, { " }}" } }
      end,
    },
  },
})

vim.b.miniai_config = { custom_textobjects = { s = { "%[%[().-()%]%]" } } }
