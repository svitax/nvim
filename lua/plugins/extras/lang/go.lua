return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "go", "gomod", "gosum" }, 1, #opts.ensure_installed)
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "staticcheck",
        "revive",
        "gomodifytags",
        "gofumpt",
        "iferr",
        "impl",
        "goimports",
      }, 0, #opts.ensure_installed)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          analyses = { unusedparams = true },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    },
  },
  {
    "olexsmir/gopher.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    ft = "go",
    config = function(_, opts)
      local gopher = require("gopher")
      gopher.setup(opts)

      vim.keymap.set("n", "<leader>ma", "<cmd>GoTagAdd json<cr>", { buffer = true, desc = "Add json tag" })
      vim.keymap.set("n", "<leader>mr", "<cmd>GoTagRm json<cr>", { buffer = true, desc = "Remove json tag" })
      vim.keymap.set("n", "<leader>mA", "<cmd>GoTagAdd yaml<cr>", { buffer = true, desc = "Add yaml tag" })
      vim.keymap.set("n", "<leader>mR", "<cmd>GoTagRm yaml<cr>", { buffer = true, desc = "Remove yaml tag" })

      vim.keymap.set("n", "<leader>mt", "<cmd>GoMod tidy<cr>", { buffer = true, desc = "go mod tidy" })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      table.insert(opts.sources, nls.builtins.diagnostics.staticcheck)
      table.insert(opts.sources, nls.builtins.diagnostics.revive)
      table.insert(opts.sources, nls.builtins.formatting.gofumpt)
      table.insert(opts.sources, nls.builtins.formatting.goimports)
      -- table.insert(
      --   opts.sources,
      --   nls.builtins.diagnostics.golangci_lint.with({
      --     args = { "run", "--fix=false", "--out-format", "json", "--path-prefix", "$ROOT" },
      --   })
      -- )
      -- table.insert(opts.sources, nls.builtins.formatting.shfmt.with({ extra_filetypes = { "zsh" } }))
      -- table.insert(opts.sources, nls.builtins.formatting.shellharden.with({ extra_filetypes = { "zsh" } }))
    end,
  },
}
