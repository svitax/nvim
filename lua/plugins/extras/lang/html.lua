return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "dcampos/cmp-emmet-vim", dependencies = "mattn/emmet-vim" },
    },
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.cmp_source_names["emmet_vim"] = "(emmet)"

      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "emmet_vim" },
      }, 1, #opts.sources))
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
      },
    },
  },
}
