return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "mtoohey31/cmp-fish", "tamago324/cmp-zsh" },
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.cmp_source_names["zsh"] = "(zsh)"
      opts.cmp_source_names["fish"] = "(fish)"

      cmp.setup.filetype({ "sh", "zsh" }, {
        sources = cmp.config.sources({ { name = "env" }, { name = "zsh" } }),
      })

      cmp.setup.filetype({ "fish" }, {
        sources = cmp.config.sources({ { name = "env" }, { name = "fish" } }),
      })

      -- opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
      --   { name = "fish", priority = 10 },
      -- }, 1, #opts.sources))
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "bash", "fish" })
      end
    end,
  },
  { "neovim/nvim-lspconfig", opts = { servers = { bashls = { filetypes = { "sh", "bash", "zsh" } } } } },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "shfmt",
        "shellharden",
        "shellcheck",
        -- "beautysh",
      }, 0, #opts.ensure_installed)
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      -- table.insert(opts.sources, nls.builtins.diagnostics.shellcheck)
      -- table.insert(opts.sources, nls.builtins.code_actions.shellcheck)
      table.insert(opts.sources, nls.builtins.diagnostics.zsh)
      table.insert(opts.sources, nls.builtins.diagnostics.fish)
      table.insert(opts.sources, nls.builtins.formatting.fish_indent)
      table.insert(opts.sources, nls.builtins.formatting.shfmt.with({ extra_filetypes = { "zsh" } }))
      table.insert(opts.sources, nls.builtins.formatting.shellharden.with({ extra_filetypes = { "zsh" } }))
      -- table.insert(opts.sources, nls.builtins.diagnostics.beautysh)
    end,
  },
}
