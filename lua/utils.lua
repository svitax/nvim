local M = {}

M.termcodes = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

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

-- lua-filesize, generate a human readable string describing the file size
-- Copyright (c) 2016 Boris Nagaev
M.si = {
  bits = { "b", "Kb", "Mb", "Gb", "Tb", "Pb", "Eb", "Zb", "Yb" },
  bytes = { "B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB" },
}

M.is_nan = function(num)
  -- http://lua-users.org/wiki/InfAndNanComparisons
  -- NaN is the only value that doesn't equal itself
  return num ~= num
end

M.round_number = function(num, digits)
  local fmt = "%." .. digits .. "f"
  return tonumber(fmt:format(num))
end

M.filesize = function(size, options)
  -- copy options to o
  local o = {}
  for key, value in pairs(options or {}) do
    o[key] = value
  end

  local function set_default(name, default)
    if o[name] == nil then
      o[name] = default
    end
  end
  set_default("bits", false)
  set_default("unix", false)
  set_default("base", 2)
  set_default("round", o.unix and 1 or 2)
  set_default("spacer", o.unix and "" or " ")
  set_default("suffixes", {})
  set_default("output", "string")
  set_default("exponent", -1)

  assert(not M.is_nan(size), "Invalid arguments")

  local ceil = (o.base > 2) and 1000 or 1024
  local negative = (size < 0)
  if negative then
    -- Flipping a negative number to determine the size
    size = -size
  end

  local result

  -- Zero is now a special case because bytes divide by 1
  if size == 0 then
    result = {
      0,
      o.unix and "" or (o.bits and "b" or "B"),
    }
  else
    -- Determining the exponent
    if o.exponent == -1 or M.is_nan(o.exponent) then
      o.exponent = math.floor(math.log(size) / math.log(ceil))
    end

    -- Exceeding supported length, time to reduce & multiply
    if o.exponent > 8 then
      o.exponent = 8
    end

    local val
    if o.base == 2 then
      val = size / math.pow(2, o.exponent * 10)
    else
      val = size / math.pow(1000, o.exponent)
    end

    if o.bits then
      val = val * 8
      if val > ceil then
        val = val / ceil
        o.exponent = o.exponent + 1
      end
    end

    result = {
      M.round_number(val, o.exponent > 0 and o.round or 0),
      (o.base == 10 and o.exponent == 1) and (o.bits and "kb" or "kB")
        or M.si[o.bits and "bits" or "bytes"][o.exponent + 1],
    }

    if o.unix then
      result[2] = result[2]:sub(1, 1)

      if result[2] == "b" or result[2] == "B" then
        result = {
          math.floor(result[1]),
          "",
        }
      end
    end
  end

  assert(result)

  -- Decorating a 'diff'
  if negative then
    result[1] = -result[1]
  end

  -- Applying custom suffix
  result[2] = o.suffixes[result[2]] or result[2]

  -- Applying custom suffix
  result[2] = o.suffixes[result[2]] or result[2]

  -- Returning Array, Object, or String (default)
  if o.output == "array" then
    return result
  elseif o.output == "exponent" then
    return o.exponent
  elseif o.output == "object" then
    return {
      value = result[1],
      suffix = result[2],
    }
  elseif o.output == "string" then
    local value = tostring(result[1])
    value = value:gsub("%.0$", "")
    local suffix = result[2]
    return value .. o.spacer .. suffix
  end
end

---@class ToggletermCmdOptions
---@field dir? string
---@field direction? string
---@field float_opts? table<string,string>

--- Opens a floating terminal.
---@param cmd string
---@param opts? ToggletermCmdOptions
M.float_term = function(cmd, opts)
  local params = { cmd = cmd, opts = opts }
  return function()
    print("hi there")
    cmd = params.cmd
    opts = params.opts
    opts = vim.tbl_deep_extend("force", {
      cmd = cmd,
      dir = require("lazyvim.util").get_root(),
      direction = "float",
      float_opts = { border = "single" },
      on_create = function()
        vim.keymap.set({ "t" }, "<C-k>", "<Up>", { buffer = true })
        vim.keymap.set({ "t" }, "<C-j>", "<Down>", { buffer = true })
        vim.keymap.set("t", "<ESC>", [[<c-\><c-n>]], { buffer = true, desc = "Exit terminal mode" })
        vim.keymap.set(
          "n",
          "<Esc>",
          "<cmd>close<cr>",
          { buffer = true, noremap = true, silent = true, desc = "Close terminal" }
        )
        vim.keymap.set(
          "n",
          "q",
          "<cmd>close<cr>",
          { buffer = true, noremap = true, silent = true, desc = "Close terminal" }
        )
      end,
    }, opts or {})
    local term = require("toggleterm.terminal").Terminal:new(opts)
    term:toggle()
  end
end

return M
