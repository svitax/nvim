local utils = require("utils")

local components = {
  mode = {
    function()
      return " " .. require("shared").modeline_icons.evil .. " "
    end,
    padding = { left = 0, right = 0 },
    color = {},
    -- component is loaded when the condition function returns `true`
    cond = function()
      return utils.is_buf_filetype("lua")
    end,
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
  },
  buf_size = {
    function()
      utils.filesize(vim.fn.wordcount().bytes, { round = 1 })
    end,
  },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(plugin)
      if plugin.override then
        require("lazyvim.util").deprecate("lualine.override", "lualine.opts")
      end

      local icons = require("lazyvim.config").icons

      local function fg(name)
        return function()
          ---@type {foreground?:number}?
          local hl = vim.api.nvim_get_hl_by_name(name, true)
          return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
        end
      end
      return {
        --[[add your custom lualine config here]]
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
        },
        sections = {
          lualine_a = { components.mode, components.search_count },
          lualine_b = { "branch" },
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
            -- stylua: ignore
            {
              function() return require("nvim-navic").get_location() end,
              cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
            },
          },
          lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = fg("Statement")
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = fg("Constant") ,
            },
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
          },
          lualine_y = {
            { "progress", separator = "", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
        extensions = { "nvim-tree" },
      }
    end,
  },
}
