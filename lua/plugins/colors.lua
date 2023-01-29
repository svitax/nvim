return {
  -- TODO: add gruvbox
  {
    "EdenEast/nightfox.nvim",
    -- lazy = true,
    opts = function()
      return {
        palettes = {
          carbonfox = {
            -- cyan = "#08bdba",
            -- blue = "#78a9ff",
            red = "#ee5396",
            green = "#5ac778",
          },
        },
        groups = {
          all = {
            AlphaButtons = { fg = "palette.blue" },
            AlphaHeader = { link = "Comment" },
            AlphaFooter = { link = "Comment" },
            AlphaShortcut = { fg = "palette.magenta" },

            LeapBackdrop = { link = "Comment" },
            LeapMatch = { bg = "palette.blue" },

            TreesitterContext = { bg = "palette.bg2" },
            Hlargs = { link = "@parameter" },

            TabLineFill = { bg = "palette.bg0" },
            TabLine = { fg = "palette.fg2", bg = "palette.bg0" },
            TabLineSel = { fg = "palette.bg0", bg = "palette.magenta.dim" },

            NvimSurroundHighlight = { fg = "palette.bg0", bg = "palette.magenta.dim" },
          },
        },
      }
    end,
  },
  -- { "nyoom-engineering/oxocarbon.nvim" },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "carbonfox",
    },
  },
  {
    "brenoprata10/nvim-highlight-colors",
    opts = { render = "background", enable_named_colors = true, enable_tailwind = true },
    event = "BufReadPost",
  },
}
