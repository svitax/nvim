return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      vim.list_extend(
        opts.servers,
        { tailwindcss = { filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" } } },
        1,
        #opts.servers
      )
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { ensure_installed = { "css" } }, 1, #opts.ensure_installed)
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "prettierd",
        "eslint-lsp",
        "css-lsp",
        -- "fixjson"
        "jsonlint",
      }, 1, #opts.ensure_installed)
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      table.insert(opts.sources, nls.builtins.formatting.prettierd)
      table.insert(opts.sources, nls.builtins.diagnostics.jsonlint.with({ extra_filetypes = { "jsonc" } }))
    end,
  },
}
