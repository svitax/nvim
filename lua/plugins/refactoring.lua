return {
  -- <leader>lr for incremental LSP renaming based on Neovim's command-preview feature.
  { "smjonas/inc-rename.nvim", config = true, cmd = "IncRename" },
  -- structural search and replace
  {
    "cshuaimin/ssr.nvim",
    config = true,
    keys = { { "<leader>sr", "<cmd>lua require('ssr').open()<cr>", mode = { "n", "x" }, desc = "Replace in files" } },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
    opts = {
      -- prompt for return type
      -- prompt_func_return_type = {
      --   go = true,
      --   java = true,
      --
      --   c = true,
      --   h = true,
      --   cpp = true,
      --   hpp = true,
      --   cxx = true,
      -- },
      -- prompt for function parameters
      -- prompt_func_param_type = {
      --   go = true,
      --   java = true,
      --
      --   c = true,
      --   h = true,
      --   cpp = true,
      --   hpp = true,
      --   cxx = true,
      -- },
    },
    keys = {
      {
        "<leader>ce",
        [[ <Esc><Cmd>lua require('refactoring').select_refactor()<CR>]],
        mode = { "n", "v" },
        desc = "Refactor",
      },
    },
  },
}
