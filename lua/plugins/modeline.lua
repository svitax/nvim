local utils = require("utils")
local shared = require("shared")

-- TODO: get this to change color based on current nightfox theme
-- maybe this is done using the fg() func in this file
local function get_spec(spec)
  local function split_nightfox_spec(str)
    local chunks = {}
    for substring in str:gmatch("([^%.]+)") do
      table.insert(chunks, substring)
    end
    return chunks
  end

  spec = split_nightfox_spec(spec)
  local specs = {}
  local valid_colorschemes = { "nightfox", "dayfox", "dawnfox", "duskfox", "nordfox", "terafox", "carbonfox" }
  if vim.tbl_contains(valid_colorschemes, vim.g.colors_name) then
    specs = require("nightfox.spec").load(vim.g.colors_name)
  end
  return vim.tbl_get(specs, unpack(spec))
end

local function hide_in_width()
  return vim.fn.winwidth(0) > 90
end

local modeline_icons = shared.modeline_icons
local git_icons = shared.git_icons
local diagnostic_icons = shared.diagnostic_icons

local function fg(name)
  return function()
    ---@type {foreground?:number}?
    local hl = vim.api.nvim_get_hl_by_name(name, true)
    return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
  end
end

local components = {
  gutter = {
    function()
      return git_icons.gutter
    end,
    padding = { left = 0, right = 0 },
    color = function(_)
      return { fg = get_spec("syntax.builtin0"), bg = get_spec("bg0") }
    end,
  },
  mode = {
    function()
      return require("shared").modeline_icons.evil
    end,
    -- component is loaded when the condition function returns `true`
    -- cond = function()
    --   return utils.is_buf_filetype("lua")
    -- end,
    -- color = function(_)
    --   return { fg = get_spec("bg0") }
    -- end,
    padding = { left = 1, right = 1 },
  },
  search_count = {
    function()
      if vim.v.hlsearch == 0 then
        return ""
      end
      local ok, count = pcall(vim.fn.searchcount, { recompute = true })
      if (not ok) or (count.current == nil) or (count.total == 0) then
        return "0/0"
      end
      if count.incomplete == 1 then
        return "?/?"
      end

      local too_many = (">%d"):format(count.maxcount)
      local total = ((count.total > count.maxcount) and too_many) or count.total
      return ("%s/%s"):format(count.current, total)
    end,
    color = function(_)
      return { bg = get_spec("bg0") }
    end,
  },
  buf_size = {
    function()
      return utils.filesize(vim.fn.wordcount().bytes, { round = 1 })
    end,
    color = function(_)
      return { bg = get_spec("bg0") }
    end,
    cond = function()
      -- not a toggleterm buf
      return (not utils.is_buf_filetype("toggleterm")) and hide_in_width()
    end,
  },
  toggleterm = {
    function()
      return modeline_icons.term .. " " .. vim.b.toggle_number
    end,
    padding = { left = 2, right = 1 },
    cond = function()
      return utils.is_buf_filetype("toggleterm")
    end,
    color = function(_)
      return { fg = get_spec("syntax.keyword") }
    end,
  },
  buf_modified = {
    function()
      -- local fg = ""
      local mod = ""
      if vim.bo.modified then
        mod = modeline_icons.save
      end
      if not vim.bo.modifiable then
        mod = modeline_icons.lock
      end
      if utils.is_buf_newfile() then
        mod = modeline_icons.new_file
      end
      if utils.is_buf_unnamed() then
        mod = modeline_icons.checkbox_blank
      end
      if utils.is_buf_filetype("alpha") then
        mod = modeline_icons.evil
      end
      -- vim.cmd("hi! lualine_filename_status gui=bold guifg=" .. fg)
      return mod
    end,
    -- color = "lualine_filename_status"
    color = function(_)
      return {
        fg = (vim.bo.modified and get_spec("syntax.builtin0"))
          or (not vim.bo.modifiable and get_spec("syntax.keyword"))
          or (utils.is_buf_newfile() and get_spec("syntax.ident"))
          or (utils.is_buf_unnamed() and get_spec("syntax.ident")),
      }
    end,
    cond = function()
      -- not a toggleterm buf
      return not utils.is_buf_filetype("toggleterm")
    end,
  },
  dir = {
    function()
      return vim.fn.expand("%:p:h:t") .. "/"
    end,
    padding = { left = 1, right = 0 },
    -- color = "lualine_filename_status",
    color = function(_)
      return {
        fg = (vim.bo.modified and get_spec("syntax.builtin0"))
          or (not vim.bo.modifiable and get_spec("syntax.keyword"))
          or (utils.is_buf_newfile() and get_spec("syntax.ident"))
          or (utils.is_buf_unnamed() and get_spec("syntax.ident"))
          or get_spec("syntax.string"),
      }
    end,
    cond = function()
      -- not a toggleterm buf
      return not utils.is_buf_filetype("toggleterm")
    end,
  },
  -- { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
  filename = {
    "filename",
    fmt = function(
      filename,
      _ --[[context]]
    )
      if utils.is_buf_unnamed() then
        return ""
      end
      return filename
    end,
    file_status = false,
    padding = { left = 0, right = 0 },
    color = function(_)
      return {
        fg = get_spec("fg1"),
        gui = "bold",
      }
    end,
    cond = function()
      -- not a toggleterm buf
      return not utils.is_buf_filetype("toggleterm")
    end,
  },
  branch = {
    "b:gitsigns_head",
    icon = git_icons.branch,
  },
  diff = {
    "diff",
    source = function()
      local gitsigns = vim.b.gitsigns_status_dict
      if vim.b.gitsigns_status_dict then
        return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed }
      end
    end,
    symbols = {
      added = git_icons.bold_added .. " ",
      modified = git_icons.bold_modified .. " ",
      removed = git_icons.bold_removed .. " ",
    },
    cond = hide_in_width,
  },
  diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = {
      error = diagnostic_icons.bold_error .. " ",
      warn = diagnostic_icons.bold_warning .. " ",
      info = diagnostic_icons.bold_info .. " ",
      hint = diagnostic_icons.bold_hint .. " ",
    },
    cond = hide_in_width,
  },
  lsp = {
    function(msg)
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
    end,
    color = { gui = "bold" },
  },
  spaces = {
    function()
      local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
      return modeline_icons.tab .. " " .. shiftwidth
    end,
  },
  -- { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
  filetype = {
    "filetype",
    fmt = function(filetype, context)
      -- if utils.is_buf_filetype("alpha") then
      --   context.options.icons_enabled = false
      --   return utils.fennec_version()
      -- end
      return filetype
    end,
  },
  location = {
    "location",
    cond = function()
      -- not a toggleterm buf
      return (not utils.is_buf_filetype("toggleterm")) and hide_in_width()
    end,
  },
  progress = {
    "progress",
    fmt = function()
      return "%P"
      -- return "%P/%L"
    end,
    cond = function()
      -- not a toggleterm buf
      return (not utils.is_buf_filetype("toggleterm")) and hide_in_width()
    end,
  },
  showmode = {
    function()
      return require("noice").api.status.mode.get()
    end,
    cond = function()
      return package.loaded["noice"] and require("noice").api.status.mode.has()
    end,
    color = fg("Constant"),
  },
  showcmd = {
    function()
      return require("noice").api.status.command.get()
    end,
    cond = function()
      return package.loaded["noice"]
        and require("noice").api.status.command.has()
        and not utils.is_buf_filetype("toggleterm")
    end,
    color = fg("Statement"),
  },
}

local nightfox_theme = function()
  local s = require("nightfox.spec").load(vim.g.colors_name)
  local p = s.palette
  local tbg = s.bg0

  return {
    normal = {
      a = { fg = p.blue.base, bg = s.bg0, gui = "bold" },
      b = { bg = s.bg0, fg = s.fg2 },
      c = { bg = tbg, fg = s.fg2 },
    },

    insert = {
      a = { fg = p.green.base, bg = s.bg0, gui = "bold" },
      -- b = { bg = p.green.base, fg = s.fg1 },
    },

    command = {
      a = { fg = p.yellow.base, bg = s.bg0, gui = "bold" },
      -- b = { bg = p.yellow.base, fg = s.fg1 },
    },

    visual = {
      a = { fg = p.magenta.base, bg = s.bg0, gui = "bold" },
      -- b = { bg = p.magenta.base, fg = s.fg1 },
    },

    replace = {
      a = { fg = p.red.base, bg = s.bg0, gui = "bold" },
      -- b = { bg = p.red.base, fg = s.fg1 },
    },

    terminal = {
      a = { fg = p.orange.base, bg = s.bg0, gui = "bold" },
      -- b = { bg = p.orange.base, fg = s.fg1 },
    },

    inactive = {
      -- a = { bg = tbg, fg = p.blue.base },
      -- b = { bg = tbg, fg = s.fg3, gui = "bold" },
      -- c = { bg = tbg, fg = s.syntax.comment },
    },
    -- normal = {
    --   a = { bg = get_spec("bg0"), fg = get_spec("blue.base"), gui = "bold" },
    --   b = { bg = get_spec("bg0"), fg = get_spec("fg1") },
    --   c = { bg = get_spec("bg0"), fg = get_spec("fg1") },
    -- },
    -- insert = {
    --   a = { bg = get_spec("bg0"), fg = get_spec("green.base"), gui = "bold" },
    --   b = { bg = get_spec("bg0"), fg = get_spec("fg1") },
    --   c = { bg = get_spec("bg0"), fg = get_spec("fg1") },
    -- },
    -- command = {
    --   a = { bg = get_spec("bg0"), fg = get_spec("yellow.base"), gui = "bold" },
    --   b = { bg = get_spec("bg0"), fg = get_spec("fg1") },
    --   c = { bg = get_spec("bg0"), fg = get_spec("fg1") },
    -- },
    -- visual = {
    --   a = { bg = get_spec("bg0"), fg = get_spec("magenta.base"), gui = "bold" },
    --   b = { bg = get_spec("bg0"), fg = get_spec("fg1") },
    --   c = { bg = get_spec("bg0"), fg = get_spec("fg1") },
    -- },
    -- replace = {
    --   a = { bg = get_spec("bg0"), fg = get_spec("red.base"), gui = "bold" },
    --   b = { bg = get_spec("bg0"), fg = get_spec("fg1") },
    --   c = { bg = get_spec("bg0"), fg = get_spec("fg1") },
    -- },
    -- terminal = {
    --   a = { bg = get_spec("bg0"), fg = get_spec("orange.base"), gui = "bold" },
    --   b = { bg = get_spec("bg0"), fg = get_spec("fg1") },
    --   c = { bg = get_spec("bg0"), fg = get_spec("fg1") },
    -- },
    -- inactive = {
    --   a = { bg = get_spec("bg0"), fg = get_spec("blue.base") },
    --   b = { bg = get_spec("bg0"), fg = get_spec("fg3"), gui = "bold" },
    --   c = { bg = get_spec("bg0"), fg = get_spec("syntax.comment") },
    -- },
  }
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(plugin)
      if plugin.override then
        require("lazyvim.util").deprecate("lualine.override", "lualine.opts")
      end

      local icons = require("lazyvim.config").icons

      return {
        --[[add your custom lualine config here]]
        extensions = { "neo-tree" },
        options = {
          theme = nightfox_theme(),
          -- theme = "auto",
          -- theme = require("nightfox.util.lualine")("carbonfox")
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { components.gutter, components.mode, components.search_count },
          lualine_b = {
            components.buf_size,
            components.toggleterm,
            components.buf_modified,
            components.dir,
            components.filename,
          },
          lualine_c = {
            components.location,
            components.progress,
            components.showcmd,
            components.showmode,
            -- {
            --   function() return require("nvim-navic").get_location() end,
            --   cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
            -- },
          },
          lualine_x = {
            components.diagnostics,
            components.lsp,
            -- { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
          },
          lualine_y = {
            components.filetype,
            -- { "progress", separator = "", padding = { left = 1, right = 0 } },
            -- { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            components.branch,
            -- function()
            --   return " " .. os.date("%R")
            -- end,
          },
        },
      }
    end,
  },
}
