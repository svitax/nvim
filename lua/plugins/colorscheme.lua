return {
  -- add gruvbox
  { "EdenEast/nightfox.nvim", lazy = true },
  -- { "nyoom-engineering/oxocarbon.nvim", lazy = true },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "carbonfox",
    },
  },
}
