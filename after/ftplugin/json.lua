vim.opt_local.conceallevel = 0

-- add trailing comma in JSON files (o in normal mode)
vim.keymap.set("n", "o", function()
  local line = vim.api.nvim_get_current_line()
  local should_add_comma = string.find(line, "[^,{[]$")
  if should_add_comma then
    return "A,<cr>"
  else
    return "o"
  end
end, { buffer = true, expr = true })

-- add trailing comma in JSON files (<cr> in insert mode)
vim.keymap.set("i", "<cr>", function()
  local line = vim.api.nvim_get_current_line()
  local should_add_comma = string.find(line, "[^,{[]$")
  if should_add_comma then
    return ",<cr>"
  else
    return "<cr>"
  end
end, { buffer = true, expr = true })
