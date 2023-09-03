local utils = require("utils")
local shared = require("shared")
local c = require("config.colors").gruvfox

-- TODO: get this to change color based on current nightfox theme
-- maybe this is done using the fg() func in this file
-- local function get_spec(spec)
--   local function split_nightfox_spec(str)
--     local chunks = {}
--     for substring in str:gmatch("([^%.]+)") do
--       table.insert(chunks, substring)
--     end
--     return chunks
--   end
--
--   spec = split_nightfox_spec(spec)
--   local specs = {}
--   local valid_colorschemes = { "nightfox", "dayfox", "dawnfox", "duskfox", "nordfox", "terafox", "carbonfox" }
--   if vim.tbl_contains(valid_colorschemes, vim.g.colors_name) then
--     specs = require("nightfox.spec").load(vim.g.colors_name)
--   end
--   return vim.tbl_get(specs, unpack(spec))
-- end

local function hide_in_width()
  return vim.fn.winwidth(0) > 90
end

local modeline_icons = shared.modeline_icons
local git_icons = shared.git_icons
local diagnostic_icons = shared.diagnostic_icons
local misc_icons = shared.misc

-- local function fg(name)
--   return function()
--     ---@type {foreground?:number}?
--     local hl = vim.api.nvim_get_hl_by_name(name, true)
--     return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
--   end
-- end

local function mode_color()
  -- stylua: ignore start
  local color_table = {
    n = c.green, i = c.blue, v = c.purple, [""] = c.purple, V = c.purple, c = c.orange, no = c.red, s = c.orange,
    S = c.orange, [""] = c.orange, ic = c.yellow, R = c.red, Rv = c.red, cv = c.red, ce = c.red, r = c.red,
    rm = c.red, ["r?"] = c.cyan, ["!"] = c.red, t = c.yellow,
  }
  -- stylua: ignore end

  return { fg = color_table[vim.fn.mode()], bg = c.bg0 }
end

local components = {
  gutter = {
    function()
      return git_icons.gutter
    end,
    padding = { left = 0, right = 1 },
    color = mode_color,
    -- color = function(_)
    --   return { fg = get_spec("syntax.builtin0"), bg = get_spec("bg0") }
    -- end,
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
    padding = { right = 1 },
    color = mode_color,
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
    -- color = { bg = colors.bg },
    -- color = function(_)
    --   return { bg = get_spec("bg0") }
    -- end,
    color = { fg = c.blue, bg = c.bg0 },
  },
  buf_size = {
    function()
      return utils.filesize(vim.fn.wordcount().bytes, { round = 1 })
    end,
    -- color = { bg = colors.bg },
    -- color = function(_)
    --   return { bg = get_spec("bg0") }
    -- end,
    cond = function()
      -- not a toggleterm buf
      return (not utils.is_buf_filetype("toggleterm")) and hide_in_width()
    end,
    color = { fg = c.fg, bg = c.bg0 },
  },
  toggleterm = {
    function()
      return modeline_icons.term .. " [" .. vim.b.toggle_number .. "]"
    end,
    padding = { left = 2, right = 1 },
    cond = function()
      return utils.is_buf_filetype("toggleterm")
    end,
    color = { fg = c.blue, bg = c.bg0 },
    -- color = function(_)
    --   return { fg = get_spec("syntax.ident") }
    -- end,
  },
  grapple = {
    function()
      local key = require("grapple").key()
      return modeline_icons.tag .. " [" .. key .. "]"
    end,
    cond = require("grapple").exists,
    color = { fg = c.blue, bg = c.bg0 },
    -- color = function(_)
    --   return { fg = get_spec("syntax.ident") }
    -- end,
  },
  modified = {
    function(props)
      if vim.api.nvim_get_option_value("modified", { buf = props.buf }) then
        return "● "
      end
      return ""
    end,
    cond = function()
      -- return utils.is_buf_filetype("NeogitCommitMessage")
      -- not a toggleterm buf
      return not utils.is_buf_filetype({ "toggleterm", "TelescopePrompt" })
    end,
    padding = { left = 1, right = 0 },
    color = { fg = c.yellow, bg = c.bg0 },
  },
  dir = {
    function()
      return vim.fn.expand("%:p:h:t") .. "/"
    end,
    padding = { left = 1, right = 0 },
    color = { fg = c.grey_dim, bg = c.bg0 },
    cond = function()
      -- not a toggleterm buf
      return not utils.is_buf_filetype({ "toggleterm", "TelescopePrompt" })
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
    -- color = function(_)
    --   return {
    --     fg = get_spec("fg1"),
    --     gui = "bold",
    --   }
    -- end,
    color = { fg = c.fg, bg = c.bg0, gui = "bold" },
    cond = function()
      -- not a toggleterm buf
      return not utils.is_buf_filetype("toggleterm")
    end,
  },
  location = {
    "location",
    cond = function()
      -- not a toggleterm buf
      return (not utils.is_buf_filetype("toggleterm")) and hide_in_width()
    end,
    color = { bg = c.bg0 },
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
    color = { bg = c.bg0 },
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
    -- color = fg("Statement"),
    -- color = { fg = c.green, bg = c.bg0 },
    color = { fg = c.fg, bg = c.bg0 },
  },
  showmode = {
    function()
      return require("noice").api.status.mode.get()
    end,
    cond = function()
      return package.loaded["noice"] and require("noice").api.status.mode.has()
    end,
    -- color = fg("Constant"),
    color = { fg = c.red, bg = c.bg0 },
  },
  showmacro = {
    function()
      return require("NeoComposer.ui").status_recording()
    end,
    -- color = fg("Constant"),
    color = { fg = c.red, bg = c.bg0 },
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
    color = { bg = c.bg0 },
  },
  -- { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
  lsp = {
    function()
      local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
      -- don't show anything if buffer is special/invalid filetype
      if vim.tbl_contains(utils.special_filetypes, vim.bo.filetype) then
        return ""
      end
      if #buf_clients == 0 then
        return "LS Inactive"
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

      local client_names_str = table.concat(unique_client_names, ", ")
      local language_servers = string.format("[%s]", client_names_str)

      return language_servers
    end,
    color = { fg = c.fg, bg = c.bg0, gui = "bold" },
    cond = function()
      return vim.g.show_lsp
    end,
  },
  filetype = {
    "filetype",
    fmt = function(filetype, context)
      -- if utils.is_buf_filetype("alpha") then
      --   context.options.icons_enabled = false
      --   return utils.fennec_version()
      -- end
      return filetype
    end,
    color = { fg = c.grey_dim, bg = c.bg0 },
  },
  python_env = {
    function()
      if vim.bo.filetype == "python" then
        local venv = require("venv-selector").get_active_venv()
        -- local venv = vim.env.VIRTUAL_ENV
        -- local venv = os.getenv("CONDA_DEFAULT_ENV") or os.getenv("VIRTUAL_ENV")
        -- local venv = require("swenv.api").get_current_venv()
        if venv then
          local icons = require("nvim-web-devicons")
          local py_icon, _ = icons.get_icon(".py")
          return string.format(py_icon .. " (env:%s)", utils.env_cleanup(venv))
        end
      end
      return ""
    end,
    -- color = function(_)
    --   return { fg = get_spec("syntax.comment") }
    -- end,
    color = { fg = c.grey_dim, bg = c.bg0 },
    cond = function()
      return (utils.is_buf_filetype("python") and hide_in_width())
    end,
  },
  branch = {
    "b:gitsigns_head",
    icon = git_icons.branch,
    color = { fg = c.purple, bg = c.bg0 },
  },
  -- branch_head = {
  --   function(props)
  --     local icon = git_icons.branch
  --     local label = {}
  --     -- local signs = vim.api.nvim_buf_get_var(props.buf, "gitsigns_head")
  --     table.insert(label, { icon .. " " .. vim.b.gitsigns_head })
  --     return label
  --   end,
  -- },
  diff = {
    function(props)
      local icons =
        { removed = git_icons.bold_removed, changed = git_icons.bold_modified, added = git_icons.bold_added }
      local labels = {}
      local signs = vim.api.nvim_buf_get_var(props.buf, "gitsigns_status_dict")
      -- local signs = vim.b.gitsigns_status_dict
      for name, icon in pairs(icons) do
        if tonumber(signs[name]) and signs[name] > 0 then
          table.insert(labels, { icon .. " " .. signs[name] .. " ", group = "Diff" .. name })
        end
      end
      if #labels > 0 then
        table.insert(labels, { "| " })
      end
      return labels
    end,
  },
  -- diff = {
  --   "diff",
  --   source = function()
  --     local gitsigns = vim.b.gitsigns_status_dict
  --     if vim.b.gitsigns_status_dict then
  --       return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed }
  --     end
  --   end,
  --   symbols = {
  --     added = git_icons.bold_added .. " ",
  --     modified = git_icons.bold_modified .. " ",
  --     removed = git_icons.bold_removed .. " ",
  --   },
  --   cond = hide_in_width,
  -- },
  -- spaces = {
  --   function()
  --     local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
  --     return modeline_icons.tab .. " " .. shiftwidth
  --   end,
  -- },

  -- overseer = {
  --   "overseer",
  --   label = "", -- Prefix for task counts
  --   colored = true, -- Color the task icons and counts
  --   symbols = {
  --     ["FAILURE"] = require("shared").task_icons.failure .. " ",
  --     ["CANCELLED"] = require("shared").task_icons.cancelled .. " ",
  --     ["SUCCESS"] = require("shared").task_icons.success .. " ",
  --     ["RUNNING"] = require("shared").task_icons.running .. " ",
  --   },
  --   unique = false, -- Unique-ify non-running task count by name
  --   name = nil, -- List of task names to search for
  --   name_not = false, -- When true, invert the name search
  --   status = nil, -- List of task statuses to display
  --   status_not = false, -- When true, invert the status search
  -- },
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
  -- { "Bekaboo/dropbar.nvim", event = "VeryLazy", opts = {} },
  -- {
  --   "b0o/incline.nvim",
  --   event = "VeryLazy",
  --   opts = function()
  --     local function get_diagnostic_label(props)
  --       -- local icons = { error = "", warn = "", info = "", hint = "" }
  --       local icons = { error = "", warn = "" }
  --       local label = {}
  --
  --       for severity, icon in pairs(icons) do
  --         local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
  --         if n > 0 then
  --           if props.focused then
  --             table.insert(label, { icon .. " " .. n .. " ", group = "DiagnosticSign" .. severity })
  --           else
  --             table.insert(label, { icon .. " " .. n .. " ", group = "Comment" })
  --           end
  --         end
  --       end
  --       if #label > 0 then
  --         if props.focused then
  --           table.insert(label, { "| " })
  --         else
  --           table.insert(label, { "| ", group = "Comment" })
  --         end
  --       end
  --       return label
  --     end
  --
  --     return {
  --       render = function(props)
  --         local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
  --         local modified = vim.api.nvim_buf_get_option(props.buf, "modified") and "bold,italic" or "bold"
  --         local filename = { fname, gui = modified }
  --         if props.focused == false then
  --           filename = vim.tbl_extend("force", filename, { guifg = c.grey_dim })
  --         end
  --
  --         -- local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(fname)
  --         -- local filetype = { ft_icon }
  --         -- if props.focused then
  --         --   filetype = vim.tbl_extend("force", filetype, { guifg = ft_color })
  --         -- else
  --         --   filetype = vim.tbl_extend("force", filetype, { guifg = c.grey_dim })
  --         -- end
  --
  --         local dname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":p:h:t") .. "/"
  --         local dirname = { dname, guifg = c.grey_dim }
  --         -- if props.focused then
  --         --   dirname = vim.tbl_extend("force", dirname, { guifg = c.blue })
  --         -- else
  --         --   dirname = vim.tbl_extend("force", dirname, { guifg = c.grey_dim })
  --         -- end
  --
  --         local modified_icon = {}
  --         if vim.api.nvim_get_option_value("modified", { buf = props.buf }) then
  --           modified_icon = vim.tbl_extend("force", { "● " }, { guifg = c.yellow })
  --         end
  --
  --         local grapple_icon = {}
  --         local key = require("grapple").key({ buffer = props.buf })
  --         if key then
  --           grapple_icon = vim.tbl_extend("force", grapple_icon, { modeline_icons.tag .. " [" .. key .. "] " })
  --         else
  --           grapple_icon = { "" }
  --         end
  --         if props.focused then
  --           grapple_icon = vim.tbl_extend("force", grapple_icon, { guifg = c.blue })
  --         else
  --           grapple_icon = vim.tbl_extend("force", grapple_icon, { guifg = c.grey_dim })
  --         end
  --
  --         -- function()
  --         --   local key = require("grapple").key()
  --         --   return modeline_icons.tag .. " [" .. key .. "]"
  --         -- end,
  --         -- cond = require("grapple").exists,
  --         -- color = { fg = c.blue, bg = c.bg0 },
  --
  --         local buffer = {
  --           { get_diagnostic_label(props) },
  --           -- filetype,
  --           -- { components.diff[1]() },
  --           grapple_icon,
  --           dirname,
  --           filename,
  --           -- { filename, gui = modified },
  --           { " " },
  --           modified_icon,
  --         }
  --         return buffer
  --       end,
  --     }
  --   end,
  -- },
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
          -- theme = "onedark",
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
            -- components.buf_size,
            components.toggleterm,
            -- components.grapple,
            -- components.buf_modified,
            components.dir,
            components.filename,
            components.modified,
            components.grapple,
            components.python_env,
          },
          lualine_c = {
            -- components.location,
            -- components.progress,
            components.showcmd,
            -- components.showmode,
            components.showmacro,
            -- {
            --   function() return require("nvim-navic").get_location() end,
            --   cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
            -- },
          },
          lualine_x = {
            components.diagnostics,
            -- components.overseer,
            components.lsp,
            -- { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
          },
          lualine_y = {
            components.filetype,
            -- components.python_env,
            components.progress,
            components.location,
            -- { "progress", separator = "", padding = { left = 1, right = 0 } },
            -- { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            -- components.branch,
            -- function()
            --   return " " .. os.date("%R")
            -- end,
          },
        },
      }
    end,
  },
}
