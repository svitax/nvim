local Util = require("lazy.core.util")

local M = {}
M.opts = {}

M.special_filetypes = {
  "noice",
  "toggleterm",
  "neotest-output",
  "neotest-summary",
  "git",
  "dap-float",
  "NeogitStatus",
  "NeogitPopup",
  "TelescopePrompt",
  "NeogitCommitMessage",
  "",
}

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

function M.check_json_key_exists(filename, key)
  -- Open the file in read mode
  local file = io.open(filename, "r")
  if not file then
    return false -- File doesn't exist or cannot be opened
  end

  -- Read the contents of the file
  local content = file:read("*all")
  file:close()

  -- Parse the JSON content
  local json_parsed, json = pcall(vim.fn.json_decode, content)
  if not json_parsed or type(json) ~= "table" then
    return false -- Invalid JSON format
  end

  -- Check if the key exists in the JSON object
  return json[key] ~= nil
end

function M.old_get_attached_clients(msg)
  -- Returns a string with a list of attached LSP clients, including
  -- formatters and linters from null-ls

  -- don't show anything if buffer is special/invalid filetype
  if vim.tbl_contains(M.special_filetypes, vim.bo.filetype) then
    return ""
  end

  local active_clients = vim.lsp.get_active_clients()
  if vim.tbl_isempty(active_clients) then
    if type(msg) == "boolean" or string.len(msg) == 0 then
      return "[LS Inactive]"
    end
    return msg
  end

  -- if next(active_clients) == nil then
  --   if type(msg) == "boolean" or string.len(msg) == 0 then
  --     return "LS Inactive"
  --   end
  --   return msg
  -- end

  -- trims a client name if window too small
  local function trim(client_name)
    if vim.fn.winwidth(0) < 100 then
      return string.sub(client_name, 1, 4)
    end
    return client_name
  end

  local buf_client_names = {}
  vim.lsp.for_each_buffer_client(0, function(client, _, _)
    if client.name ~= "null-ls" and client.name ~= "copilot" then
      local client_name = trim(client.name)
      table.insert(buf_client_names, client_name)
    end
  end)

  local function list_registered_providers_names(filetype)
    local s = require("null-ls.sources")
    local available_sources = s.get_available(filetype)
    local registered = {}
    for _, source in ipairs(available_sources) do
      for method in pairs(source.methods) do
        registered[method] = registered[method] or {}
        local source_name = trim(source.name)
        table.insert(registered[method], source_name)
      end
    end
    return registered
  end

  local function list_registered(filetype, method)
    local registered_providers = list_registered_providers_names(filetype)
    return registered_providers[method] or {}
  end

  local buf_ft = vim.bo.filetype
  local supported_formatters = list_registered(buf_ft, "NULL_LS_FORMATTING")
  local supported_linters = list_registered(buf_ft, "NULL_LS_DIAGNOSTICS")

  vim.list_extend(buf_client_names, supported_formatters)
  vim.list_extend(buf_client_names, supported_linters)

  if vim.tbl_isempty(buf_client_names) then
    buf_client_names = { "LS Inactive" }
  end

  local uniq_client_names = vim.fn.uniq(buf_client_names)
  local language_servers = "[" .. table.concat(uniq_client_names, ", ") .. "]"

  return language_servers
end

-- Define the appearance for texts displayed in quickfix
function M.qftf(info)
  local items
  local ret = {}
  -- The name of item in list is based on the directory of quickfix window.
  -- Change the directory for quickfix window make the name of item shorter.
  -- It's a good opportunity to change current directory in quickfixtextfunc :)
  --
  -- local alterBufnr = fn.bufname('#') -- alternative buffer is the buffer before enter qf window
  -- local root = getRootByAlterBufnr(alterBufnr)
  -- vim.cmd(('noa lcd %s'):format(fn.fnameescape(root)))
  --
  if info.quickfix == 1 then
    items = vim.fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
  local limit = 31
  local fnameFmt1, fnameFmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
  local validFmt = "%s │%5d:%-3d│%s %s"
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ""
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = vim.fn.bufname(e.bufnr)
        if fname == "" then
          fname = "[No Name]"
        else
          fname = fname:gsub("^" .. vim.env.HOME, "~")
        end
        -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
        if #fname <= limit then
          fname = fnameFmt1:format(fname)
        else
          fname = fnameFmt2:format(fname:sub(1 - limit))
        end
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
      str = validFmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end

function M.get_attached_clients()
  local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
  -- don't show anything if buffer is special/invalid filetype
  if vim.tbl_contains(M.special_filetypes, vim.bo.filetype) then
    -- return ""
    return {}
  end
  if #buf_clients == 0 then
    -- return "LS Inactive"
    return {}
  end

  local buf_ft = vim.bo.filetype
  local buf_client_names = {}

  -- add client
  for _, client in pairs(buf_clients) do
    if client.name ~= "copilot" and client.name ~= "null-ls" then
      table.insert(buf_client_names, client.name)
    end
  end

  -- Generally, you should use either null-ls or nvim-lint + formatter.nvim, not both.

  -- Add sources (from null-ls)
  -- null-ls registers each source as a separate attached client, so we need to filter for unique names down below.
  local null_ls_s, null_ls = pcall(require, "null-ls")
  if null_ls_s then
    local sources = null_ls.get_sources()
    for _, source in ipairs(sources) do
      if source._validated then
        for ft_name, ft_active in pairs(source.filetypes) do
          if ft_name == buf_ft and ft_active then
            table.insert(buf_client_names, source.name)
          end
        end
      end
    end
  end

  -- Add linters (from nvim-lint)
  local lint_s, lint = pcall(require, "lint")
  if lint_s then
    for ft_k, ft_v in pairs(lint.linters_by_ft) do
      if type(ft_v) == "table" then
        for _, linter in ipairs(ft_v) do
          if buf_ft == ft_k then
            table.insert(buf_client_names, linter)
          end
        end
      elseif type(ft_v) == "string" then
        if buf_ft == ft_k then
          table.insert(buf_client_names, ft_v)
        end
      end
    end
  end

  -- Add formatters (from formatter.nvim)
  local formatter_s, _ = pcall(require, "formatter")
  if formatter_s then
    local formatter_util = require("formatter.util")
    for _, formatter in ipairs(formatter_util.get_available_formatters_for_ft(buf_ft)) do
      if formatter then
        table.insert(buf_client_names, formatter)
      end
    end
  end

  -- This needs to be a string only table so we can use concat below
  local unique_client_names = {}
  for _, client_name_target in ipairs(buf_client_names) do
    local is_duplicate = false
    for _, client_name_compare in ipairs(unique_client_names) do
      if client_name_target == client_name_compare then
        is_duplicate = true
      end
      -- mark ruff_lsp and ruff from null-ls as duplicates
      if client_name_target == "ruff" and client_name_compare == "ruff_lsp" then
        is_duplicate = true
      end
    end
    if not is_duplicate then
      table.insert(unique_client_names, client_name_target)
    end
  end

  -- local client_names_str = table.concat(unique_client_names, ", ")
  -- local language_servers = string.format("[%s]", client_names_str)
  -- return language_servers

  return unique_client_names
end

function M.is_client_attached(client_names)
  local attached_clients = M.get_attached_clients()
  local names_to_check = {}
  if type(client_names) == "string" then
    names_to_check = { client_names }
  elseif type(client_names) == "table" then
    names_to_check = client_names
  end
  for _, name in ipairs(names_to_check) do
    if vim.tbl_contains(attached_clients, name) then
      return true
    end
  end
  return false
end

function M.toggle_lsp_in_modeline()
  vim.g.show_lsp = not vim.g.show_lsp
  if vim.g.show_lsp then
    Util.info("Enabled show lsp in modeline", { title = "Modeline" })
  else
    Util.warn("Disabled show lsp in modeline", { title = "Modeline" })
  end
end

return M
