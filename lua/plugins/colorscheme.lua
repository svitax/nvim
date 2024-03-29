return {
  {
    -- Highlight hex/rgb/css colors
    "brenoprata10/nvim-highlight-colors",
    opts = { render = "background", enable_named_colors = true },
    event = "BufReadPost",
  },
  -- Configure LazyVim to load gruvbox
  { "LazyVim/LazyVim", opts = { colorscheme = "terafox" } },
  -- { "LazyVim/LazyVim", opts = { colorscheme = "onedark" } },
  -- {
  --   "olimorris/onedarkpro.nvim",
  --   priority = 1000, -- Ensure it loads first
  --   opts = {
  --     colors = require("config.colors").gruvfox,
  --     highlights = require("config.highlights"),
  --     styles = {
  --       comments = "italic",
  --       methods = "bold",
  --       functions = "bold",
  --     },
  --     options = {
  --       transparency = false,
  --       terminal_colors = true,
  --       -- highlight_inactive_windows = true,
  --     },
  --   },
  -- },
  {
    "EdenEast/nightfox.nvim",
    opts = function()
      local C = require("nightfox.lib.color")
      local Shade = require("nightfox.lib.shade")
      local specs = require("nightfox.spec").load("terafox")
      return {
        palettes = {
          terafox = {
            -- Shade.new(base, bright, dim, light)
            black = Shade.new("#0d0e0f", "#4e5157", "#282a30"),
            red = Shade.new("#ea6962", "#eb746b", "#543834"),
            green = Shade.new("#a9b665", "#8eb2af", "#3d4f2f"),
            yellow = Shade.new("#d8a657", "#fdb292", "#826434"),
            blue = Shade.new("#7daea3", "#73a3b7", "#2b3d4f"),
            magenta = Shade.new("#d4879c", "#b97490", "#6b454f"),
            cyan = Shade.new("#83a598", "#afd4de", "#89aeb8"),
            white = Shade.new("#e7d7ad", "#eeeeee", "#c8c8c8"),
            orange = Shade.new("#e78a4e", "#ff9664", "#66493c"),
            pink = Shade.new("#d38d97", "#d38d97", "#ad6771"),

            git_add = "#a9b665",
            git_removed = "#ea6962",
            git_changed = "#d8a657",
            git_conflict = "#e78a4e",
            git_ignored = "#665c54",

            diff_add = C("#171a1a"):blend(C("#a9b665"), 0.2):to_css(), -- bg1, green
            diff_delete = C("#171a1a"):blend(C("#ea6962"), 0.25):to_css(), -- bg1, red
            diff_change = C("#171a1a"):blend(C("#d8a657"), 0.2):to_css(), -- bg1, yellow
            diff_text = C("#171a1a"):blend(C("#d8a657"), 0.35):to_css(), -- bg1, yellow

            comment = "#665c54",

            bg0 = "#171a1a", -- Dark bg (status line and float)
            bg1 = "#1d2021", -- Default bg
            bg2 = "#252323", -- Lighter bg (colorcolm folds)
            bg3 = "#32302f", -- Lighter bg (cursor line)
            bg4 = "#504945", -- Conceal, border fg

            fg0 = "#dcc9aa", -- Lighter fg
            fg1 = "#d4be98", -- Default fg
            fg2 = "#ccb386", -- Darker fg (status line)
            fg3 = "#c5a774", -- Darker fg (line numbers, fold colums)

            sel0 = "#2F3132", -- Popup bg, visual selection bg
            -- sel1 = "#C7B68A", -- Popup sel bg, search bg
            sel1 = "#d8a657", -- Popup sel bg, search bg
          },
          -- carbonfox = {
          --   -- cyan = "#08bdba",
          --   -- blue = "#78a9ff",
          --   red = "#ee5396",
          --   green = "#5ac778",
          -- },
        },
        specs = {
          terafox = {
            syntax = {
              bracket = "fg0", -- Brackets and Punctuation
              builtin0 = "red", -- Builtin variable
              builtin1 = "cyan", -- Builtin type
              builtin2 = "orange", -- Builtin const
              builtin3 = "red", -- Not used
              comment = "comment", -- Comment
              conditional = "magenta", -- Conditional and loop
              const = "orange", -- Constants, imports and booleans
              dep = "fg3", -- Deprecated
              field = "blue", -- Field
              func = "blue", -- Functions and Titles
              -- func = "yellow", -- Functions and Titles
              ident = "cyan", -- Identifiers
              -- keyword = "magenta", -- Keywords
              keyword = "red", -- Keywords
              number = "orange", -- Numbers
              operator = "fg2", -- Operators
              preproc = "pink", -- PreProc
              regex = "yellow", -- Regex
              statement = "magenta", -- Statements
              string = "green", -- Strings
              type = "yellow", -- Types
              variable = "white", -- Variables
            },
          },
        },
        groups = {
          terafox = {
            Pmenu = { fg = "palette.fg1", bg = "palette.bg2" }, -- Popup menu: normal item.
            PmenuSel = { bg = "palette.bg4" }, -- Popup menu: selected item.
            PmenuThumb = { bg = "palette.bg3" }, -- Popup menu: Thumb of the scrollbar.
            LineNr = { fg = "palette.bg4" }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
            CursorLineNr = { fg = "palette.comment" }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
            MatchParen = { fg = "palette.magenta" }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
            Search = { fg = "palette.fg1", bg = "palette.bg4" }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
            WinSeparator = { fg = "palette.comment" }, -- Column separting windows
            FoldColumn = { fg = "palette.comment" },

            Function = { fg = "palette.yellow" },

            TabLineFill = { bg = "palette.bg1" },
            TabLine = { fg = "palette.comment", bg = "palette.bg1" },
            TabLineSel = { fg = "palette.fg2", bg = "palette.bg3" },

            AlphaButtons = { fg = "palette.blue" },
            AlphaHeader = { link = "Comment" },
            AlphaFooter = { link = "Comment" },
            AlphaShortcut = { fg = "palette.magenta" },

            DashboardDesc = { fg = "palette.red" },
            DashboardKey = { fg = "palette.magenta" },
            DashboardIcon = { fg = "palette.red" },
            -- DashboardShortCut = {},
            DashboardFooter = { fg = "palette.comment" },
            DashboardHeader = { fg = "palette.comment" },

            -- FIX: Leap highlight groups not being applied.
            LeapBackdrop = { link = "Comment" },
            LeapMatch = { fg = "palette.bg1", bg = "palette.blue" },

            TreesitterContext = { bg = "palette.bg0" },

            Hlargs = { link = "@parameter" },

            CmpItemAbbrMatch = { fg = "palette.blue" },
            CmpItemAbbrMatchFuzzy = { fg = "palette.blue" },

            NvimSurroundHighlight = { fg = "palette.bg0", bg = "palette.magenta" },

            FloatBorder = { fg = "palette.comment" },

            -- FIX: Portal highlight groups not being applied.
            -- PortalBorderForward = { fg = "#fab387" },
            -- PortalBorderBackward = { fg = "#89b4fa" },
            -- PortalBorder = { fg = "#fab387" },
            -- PortalBorderNone = { fg = "#89b4fa" },
            -- PortalLabel = { bg = "palette.blue", fg = "palette.bg0" },

            PackageInfoOutdatedVersion = { fg = "palette.orange" },
            PackageInfoUpToDateVersion = { fg = "palette.comment" },

            -- DiffAdd = { bg = "palette.diff_add" },
            -- DiffChange = { bg = "palette.diff_change" },
            -- DiffText = { bg = "palette.diff_text" },
            -- DiffDelete = { bg = "palette.diff_delete" },

            -- NeogitBranch = { fg = "palette.magenta" },
            -- NeogitRemote = { fg = "palette.green" },
            -- NeogitHunkHeader = { fg = "palette.comment", bg = "palette.bg2" },
            -- NeogitHunkHeaderHighlight = { fg = "palette.fg2", bg = "palette.bg3" },
            -- NeogitDiffContext = { fg = "palette.comment", bg = "palette.bg0" },
            -- NeogitDiffAdd = { bg = "palette.bg0" },
            -- NeogitDiffDelete = { bg = "palette.bg0" },
            -- NeogitDiffContextHighlight = { bg = "palette.bg0" },
            -- NeogitDiffAddHighlight = { fg = "palette.git_add", bg = "palette.diff_add" },
            -- NeogitDiffDeleteHighlight = { fg = "palette.git_removed", bg = "palette.diff_delete" },
            --
            -- NeogitPopupSwitchKey = { fg = "palette.magenta" },
            -- NeogitPopupOptionKey = { fg = "palette.magenta" },
            -- NeogitPopupConfigKey = { fg = "palette.magenta" },
            -- NeogitPopupActionKey = { fg = "palette.magenta" },
            -- NeogitCursorLine = { bg = "palette.bg3" },
            -- NeogitChangeRenamed = { fg = "palette.magenta", gui = "italic,bold" },
            -- NeogitUntrackedfiles = { fg = "palette.magenta", gui = "bold" },
            -- NeogitUnstagedchanges = { fg = "palette.magenta", gui = "bold" },
            -- NeogitUnmergedchanges = { fg = "palette.magenta", gui = "bold" },
            -- NeogitUnpulledchanges = { fg = "palette.magenta", gui = "bold" },
            -- NeogitRecentcommits = { fg = "palette.magenta", gui = "bold" },
            -- NeogitStagedchanges = { fg = "palette.magenta", gui = "bold" },
            -- NeogitStashes = { fg = "palette.magenta", gui = "bold" },
            -- NeogitRebasing = { fg = "palette.magenta", gui = "bold" },

            NeogitNormal = { bg = "palette.bg1" },
            NeogitWinSeparator = { bg = "palette.bg1", fg = "palette.comment" },
            NeogitNotification = { bg = "palette.bg1" },
            NeogitCursorLine = { bg = "palette.bg3" },
            NeogitCursorLineNr = {
              fg = "palette.comment", --[[bg = c.bg15]]
            },
            NeogitDiffHeader = { bg = "palette.bg4", fg = "palette.blue", style = "underline" },
            NeogitDiffHeaderHighlight = { bg = "palette.bg4", fg = "palette.orange", style = "bold,underline" },
            NeogitDiffContext = { bg = "palette.bg1" },
            NeogitDiffContextHighlight = { bg = "palette.bg2" },

            -- NeogitHunkHeader = { bg = "palette.fg2", fg = "palette.bg1", style = "bold" },
            NeogitHunkHeader = { fg = "palette.fg2", bg = "palette.bg3", gui = "bold" },
            NeogitHunkHeaderHighlight = { bg = "palette.magenta", fg = "palette.bg1", gui = "bold" },

            HighlightUndo = { bg = "palette.magenta", fg = "palette.bg1" },

            TelescopeBorder = { bg = "palette.bg0" },
            TelescopeNormal = { bg = "palette.bg0" },

            -- Nvchad Telescope theme
            TelescopePreviewBorder = { fg = "palette.bg0", bg = "palette.bg0" },
            TelescopePreviewNormal = { bg = "palette.bg0" },
            TelescopePreviewTitle = { fg = "palette.bg0", bg = "palette.green" },
            TelescopePromptBorder = { fg = "palette.bg3", bg = "palette.bg3" },
            TelescopePromptNormal = { fg = "palette.fg1", bg = "palette.bg3" },
            TelescopePromptPrefix = { fg = "palette.red", bg = "palette.bg3" },
            TelescopePromptTitle = { fg = "palette.bg0", bg = "palette.red" },
            TelescopeResultsBorder = { fg = "palette.bg0", bg = "palette.bg0" },
            TelescopeResultsNormal = { bg = "palette.bg0" },
            TelescopeResultsTitle = { fg = "palette.bg0", bg = "palette.bg0" },

            -- MoreMsg = { fg = "palette.comment", bg = "palette.bg1" },

            -- GlancePreviewNormal = { bg = "palette.bg0" },
            -- GlanceWinBarFilename = { fg = "palette.sel1", bg = "palette.bg3" },
            -- GlanceWinBarFilepath = { fg = "palette.sel1", bg = "palette.bg3" },
            -- GlanceWinBarTitle = { fg = "palette.sel1", bg = "palette.bg3" },
            -- GlanceListNormal = { bg = "palette.bg0" },
            -- GlanceListEndOfBuffer = { bg = "palette.bg0" },

            MultiCursor = { fg = "palette.fg1", bg = "palette.bg3" },
            MultiCursorMain = { fg = "palette.fg1", bg = "palette.bg3" },

            CodeActionLabel = { fg = "palette.blue" },

            ["@text.strong"] = { fg = "palette.orange", style = "bold" },
            ["@text.emphasis"] = { fg = "palette.orange", style = "italic" },

            ["@text.title.1.markdown"] = { fg = "palette.red" },
            ["@text.title.2.markdown"] = { fg = "palette.orange" },
            ["@text.title.3.markdown"] = { fg = "palette.yellow" },
            ["@text.title.4.markdown"] = { fg = "palette.green" },
            ["@text.title.5.markdown"] = { fg = "palette.blue" },
            ["@text.title.6.markdown"] = { fg = "palette.magenta" },
            ["@text.title.1.marker.markdown"] = { fg = "palette.red" },
            ["@text.title.2.marker.markdown"] = { fg = "palette.orange" },
            ["@text.title.3.marker.markdown"] = { fg = "palette.yellow" },
            ["@text.title.4.marker.markdown"] = { fg = "palette.green" },
            ["@text.title.5.marker.markdown"] = { fg = "palette.blue" },
            ["@text.title.6.marker.markdown"] = { fg = "palette.magenta" },
          },
        },
      }
    end,
  },
}
