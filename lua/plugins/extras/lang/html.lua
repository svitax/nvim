return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- { "dcampos/cmp-emmet-vim", dependencies = "mattn/emmet-vim" },
      -- TODO: nvim-cmp-ts-tag-close doesn't work in neovim 0.9
      -- { "buschco/nvim-cmp-ts-tag-close", config = true },
    },
    opts = function(_, opts)
      -- local cmp = require("cmp")

      -- opts.cmp_source_names["emmet_vim"] = "(emmet)"
      -- opts.cmp_source_names["nvim-cmp-ts-tag-close"] = "(tag-close)"

      -- opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
      -- { name = "emmet_vim" },
      -- { name = "nvim-cmp-ts-tag-close" },
      -- }, 1, #opts.sources))
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { ensure_installed = { "html" } }, 1, #opts.ensure_installed)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        ---@type lspconfig.options.html
        html = {},
        emmet_ls = {
          filetypes = { "html", "css", "javascriptreact", "typescriptreact" },
          -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79
          -- init_options = { html = { options = {} }, javascriptreact = { options = {} } },
        },
      },
    },
  },
}
