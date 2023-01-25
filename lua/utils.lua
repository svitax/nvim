local M = {}

M.is_table = function(x)
  return type(x) == "table"
end

M.is_string = function(x)
  return type(x) == "string"
end

M.contains = function(xs, x)
  for _, val in ipairs(xs) do
    if val == x then
      return true
    end
  end
  return false
end

M.is_buf_filetype = function(filetypes)
  if M.is_table(filetypes) then
    return M.contains(filetypes, vim.bo.filetype)
  end

  if M.is_string(filetypes) then
    return M.contains({ filetypes }, vim.bo.filetype)
  end
end

M.is_buf_newfile = function()
  local filename = vim.fn.expand("%")
  return filename ~= "" and vim.bo.buftype == "" and vim.fn.filereadable(filename) == 0
end

M.is_buf_unnamed = function()
  return vim.fn.expand("%") == ""
end

M.is_nan = function(num)
  return num ~= num
end

M.round_number = function(num, digits)
  local fmt = "%." .. digits .. "f"
  return tonumber(fmt.format(num))
end

M.filesize = function(size, options)
  local o = {}

  for key, value in pairs(options or {}) do
    o[key] = value
  end

  local function set_default(name, default)
    if o.name == nil then
      o.name = default
    end
  end

  set_default("bits", false)
  set_default("unix", false)
  set_default("base", 2)
  set_default("round", (o.unix and 1) or 2)
  set_default("spacer", (o.unix and "") or " ")
  set_default("suffixes", {})
  set_default("output", "string")
  set_default("exponent", -1)

  local ceil = ((o.base > 2) and 1000) or 1024
  local negative = size < 0
  if negative then
    size = -size
  end
  local result = nil
end

return M
