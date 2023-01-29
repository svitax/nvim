return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/playground",
      -- Better treesitter indents
      "yioneko/nvim-yati",
      "yioneko/vim-tmindent",
      -- wisely add "end" in ruby, lua, vimscript, etc. treesitter aware.
      "RRethy/nvim-treesitter-endwise",
      -- Sticky headers
      { "nvim-treesitter/nvim-treesitter-context", config = true },
      {
        "andymass/vim-matchup",
        config = function()
          vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
        end,
      },
    },
    opts = {
      playground = { enable = true },
      -- indent = { enable = true, disable = { "yaml", "python" } },
      indent = { enable = false },
      yati = {
        enable = true,
        default_lazy = true,
        default_fallback = function(lnum, computed, bufnr)
          local tm_fts = {
            "c",
            "cpp",
            "lua",
            "python",
            "html",
            "json",
            "css",
            "less",
            "scss",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "rust",
            "yaml",
            "gitcommit",
            "gitignore",
          }
          if vim.tbl_contains(tm_fts, vim.bo[bufnr].filetype) then
            return require("tmindent").get_indent(lnum, bufnr) + computed
          end
          -- or any other fallback methods
          return require("nvim-yati.fallback").vim_auto(lnum, computed, bufnr)
        end,
      },
      endwise = { enable = true },
      matchup = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          scope_incremental = "<S-CR>",
          node_decremental = "<BS>",
        },
      },
    },
  },

  { "zbirenbaum/neodim", event = "LspAttach", opts = { alpha = 0.60, update_in_insert = { enable = false } } },
  -- highlight arguments' definitions and usages
  {
    "m-demare/hlargs.nvim",
    dependencies = { "nvim-treesitter" },
    event = "BufReadPost",
    opts = { paint_arg_declarations = false },
  },
  { "folke/todo-comments.nvim", opts = { highlight = { after = "" }, signs = false } },
  -- { "MTDL9/vim-log-highlighting", ft = "log" },
  { "NMAC427/guess-indent.nvim", event = "BufReadPost", config = true },
}
