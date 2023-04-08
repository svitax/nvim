return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "dcampos/cmp-emmet-vim", dependencies = "mattn/emmet-vim" },
      { "David-Kunz/cmp-npm", opts = { only_semantic_versions = true } },
    },
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.cmp_source_names["emmet_vim"] = "(emmet)"
      opts.cmp_source_names["npm"] = "(npm)"

      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "emmet_vim" },
        { name = "npm", keyword_length = 4, priority = 10 },
      }, 1, #opts.sources))
    end,
  },
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = "BufReadPre package.json",
    config = function(_, opts)
      require("package-info").setup(opts)
      vim.keymap.set(
        "n",
        "<leader>mc",
        "<cmd>lua require('package-info').change_version()<cr>",
        { desc = "Change version", buffer = true }
      )
      vim.keymap.set(
        "n",
        "<leader>md",
        "<cmd>lua require('package-info').delete()<cr>",
        { desc = "Delete package", buffer = true }
      )
      vim.keymap.set(
        "n",
        "<leader>mi",
        "<cmd>lua require('package-info').install()<cr>",
        { desc = "Install package", buffer = true }
      )
      vim.keymap.set(
        "n",
        "<leader>mr",
        "<cmd>lua require('package-info').reinstall()<cr>",
        { desc = "Reinstall dependencies", buffer = true }
      )
      vim.keymap.set(
        "n",
        "<leader>mt",
        "<cmd>lua require('package-info').toggle()<cr>",
        { desc = "Toggle package-info", buffer = true }
      )
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { ensure_installed = { "css", "html" } }, 1, #opts.ensure_installed)
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
      }, 0, #opts.ensure_installed)
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
