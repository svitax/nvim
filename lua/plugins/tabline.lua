return {
  {
    "nanozuki/tabby.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader><tab>d", "<cmd>tabclose<cr>", desc = "Delete tab" },
      { "<leader><tab>N", "<cmd>$tabnew<cr>", desc = "New tab" },
      { "<leader><tab>;", "<cmd>tabn<cr>", desc = "Next tab" },
      { "<leader><tab>l", "<cmd>tabp<cr>", desc = "Previous tab" },
      -- { "<leader><tab>n", "<cmd>tabn<cr>", desc = "Next tab" },
      -- { "<leader><tab>p", "<cmd>tabp<cr>", desc = "Previous tab" },
      { "<leader><tab>:", "<cmd>+tabmove<cr>", desc = "Move tab right" },
      { "<leader><tab>L", "<cmd>-tabmove<cr>", desc = "Move tab left" },
    },
    config = function()
      local function tab_name(tab)
        return string.gsub(tab, "%[..%]", "")
      end

      local theme = {
        fill = "TabLineFill",
        -- Also you can do this:
        -- fill = { fg = "#f2e9de", bg = "#0c0c0c" },
        head = "TabLine",
        current_tab = "TabLineSel",
        -- current_tab = { fg = "#F8FBF6", bg = "#896a98" },
        tab = "TabLine",
        win = "TabLine",
        tail = "TabLine",
      }

      require("tabby.tabline").set(function(line)
        return {
          {
            { "  ", hl = theme.head },
            line.sep("", theme.head, theme.fill),
          },
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
              line.sep("", hl, theme.fill),
              tab.number(),
              -- "",
              tab_name(tab.name()),
              -- "",
              line.sep("", hl, theme.fill),
              hl = hl,
              margin = " ",
            }
          end),
          line.spacer(),
          -- line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
          --   local hl = win.is_current() and theme.current_tab or theme.tab
          --   return {
          --     line.sep("", hl, theme.fill),
          --     win.file_icon(),
          --     " ",
          --     win.buf_name(),
          --     " ",
          --     -- win.buf().id,
          --     line.sep("", hl, theme.fill),
          --     hl = hl,
          --     margin = " ",
          --   }
          -- end),
          {
            line.sep("", theme.tail, theme.fill),
            { "  ", hl = theme.tail },
          },
          hl = theme.fill,
        }
      end)
    end,
  },
  { "tiagovla/scope.nvim", event = "VeryLazy", config = true },
}
