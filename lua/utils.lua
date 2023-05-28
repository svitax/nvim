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
        -- vim.keymap.set(
        --   "n",
        --   "q",
        --   "<cmd>close<cr>",
        --   { buffer = true, noremap = true, silent = true, desc = "Close terminal" }
        -- )
      end,
    }, opts or {})
    local term = require("toggleterm.terminal").Terminal:new(opts)
    term:toggle()
  end
end

-- returns the head directory
---@return string
function M.get_head_dir()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  local head = path ~= "" and path:match("(.*/)") or nil
  if not head then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    head = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    head = head and vim.fs.dirname(head) or vim.loop.cwd()
  end
  ---@cast head string
  return head
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

function M.split(input, delimiter)
  local arr = {}
  local _ = string.gsub(input, "[^" .. delimiter .. "]+", function(w)
    table.insert(arr, w)
  end)
  return arr
end

function M.env_cleanup(venv)
  local params = M.split(venv, "/")
  return params[#params - 1]
end

-- function M.env_cleanup(venv)
--   if string.find(venv, "/") then
--     local final_venv = venv
--     for w in venv:gmatch("([^/]+)") do
--       final_venv = w
--     end
--     venv = final_venv
--   end
--   return venv
-- end

--- Add a source to cmp
-- @param source the cmp source string or table to add (see cmp documentation for source table format)
function M.add_cmp_source(source)
  -- load cmp if available
  local cmp_avail, cmp = pcall(require, "cmp")
  if cmp_avail then
    -- get the current cmp config
    local config = cmp.get_config()
    -- add the source to the list of sources
    table.insert(config.sources, source)
    -- call the setup function again
    cmp.setup(config)
  end
end

-- this will return a function that calls telescope.
-- cwd will default to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    require("telescope.builtin")[builtin](opts)
  end
end

-- Close quickfix and loclist, then switch any active windows, then delete buffer from buffer list
function M.close_buffer()
  vim.cmd.cclose()
  vim.cmd.lclose()
  local ok, bufdelete = pcall(require, "bufdelete")
  if ok then
    bufdelete.bufdelete(0)
  else
    vim.cmd.bdelete({ bang = true })
  end
end

---Get normalised colour
---@param name string like 'pink' or '#fa8072'
---@return string[]
function M.get_color(name)
  local color = vim.api.nvim_get_color_by_name(name)
  if color == -1 then
    color = vim.opt.background:get() == "dark" and 000 or 255255255
  end

  ---Convert colour to hex
  ---@param value integer
  ---@param offset integer
  ---@return integer
  local byte = function(value, offset)
    return bit.band(bit.rshift(value, offset), 0xFF)
  end

  return { byte(color, 16), byte(color, 8), byte(color, 0) }
end

---Get visually transparent volour
---@param fg string like 'pink' or '#fa8072'
---@param bg string like 'pink' or '#fa8072'
---@param alpha integer number between 0 and 1
---@return string
function M.blend(fg, bg, alpha)
  local bg_color = M.get_color(bg)
  local fg_color = M.get_color(fg)

  ---@param i integer
  ---@return integer
  local channel = function(i)
    local ret = (alpha * fg_color[i] + ((1 - alpha) * bg_color[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format("#%02X%02X%02X", channel(1), channel(2), channel(3))
end

function M.find(word, ...)
  for _, str in ipairs({ ... }) do
    local match_start, match_end = string.find(word, str)
    if match_start then
      return str, match_start, match_end
    end
  end
end

--- Call the given function and use `vim.notify` to notify of any errors.
--- This function is a wrapper around `xpcall` which allows having a single error handler for all errors
--- @param msg string
--- @param func function
--- @vararg any
--- @return boolean, any
--- @overload fun(fun: function, ...): boolean, any
function M.wrap_err(msg, func, ...)
  local args = { ... }
  if type(msg) == "function" then
    args, func, msg = { func, unpack(args) }, msg, nil
  end
  return xpcall(func, function(err)
    msg = msg and string.format("%s:\n%s", msg, err) or err
    vim.schedule(function()
      vim.notify(msg, vim.log.levels.ERROR, { title = "ERROR" })
    end)
  end, unpack(args))
end

function M.open_help(tag)
  M.wrap_err(vim.cmd.help, tag)
end

--- Stolen from nlua.nvim this function attempts to open vim help docs if an api or vim.fn function
--- otherwise it shows the lsp hover doc
--- @param word string
--- @param callback function
function M.keyword(word, callback)
  local original_iskeyword = vim.bo.iskeyword

  vim.bo.iskeyword = vim.bo.iskeyword .. ",."
  word = word or vim.fn.expand("<cword>")

  vim.bo.iskeyword = original_iskeyword

  local match, _, end_idx = M.find(word, "api.", "vim.api.")
  if match and end_idx then
    return M.open_help(word:sub(end_idx + 1))
  end

  match, _, end_idx = M.find(word, "fn.", "vim.fn.")
  if match and end_idx then
    return M.open_help(word:sub(end_idx + 1) .. "()")
  end

  match, _, end_idx = M.find(word, "^vim.(%w+)")
  if match and end_idx then
    return M.open_help(word:sub(1, end_idx))
  end

  if callback then
    return callback()
  end

  vim.lsp.buf.hover()
end

return M
