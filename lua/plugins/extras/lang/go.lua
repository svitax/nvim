return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "go", "gomod", "gosum", "gowork" }, 1, #opts.ensure_installed)
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
          gofumpt = true,
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          semanticTokens = true,
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          analyses = {
            fieldalignment = true,
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    },
    setup = {
      gopls = function(_, opts)
        -- workaround for gopls not supporting semanticTokensProvider
        -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
        require("lazyvim.util").on_attach(function(client, _)
          if client.name == "gopls" then
            if not client.server_capabilities.semanticTokensProvider then
              local semantic = client.config.capabilities.textDocument.semanticTokens
              client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {
                  tokenTypes = semantic.tokenTypes,
                  tokenModifiers = semantic.tokenModifiers,
                },
                range = true,
              }
            end
          end
        end)
        -- end workaround
      end,
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
      if type(opts.sources) == "table" then
        local nls = require("null-ls")
        vim.list_extend(opts.sources, {
          nls.builtins.code_actions.gomodifytags,
          nls.builtins.code_actions.impl,
          nls.builtins.formatting.gofumpt,
          nls.builtins.formatting.goimports_reviser,
          -- nls.builtins.diagnostics.revive
          -- nls.builtins.diagnostics.staticcheck,
        })
      end
      -- local nls = require("null-ls")
      -- table.insert(opts.sources, nls.builtins.diagnostics.staticcheck)
      -- table.insert(opts.sources, nls.builtins.diagnostics.revive)
      -- table.insert(opts.sources, nls.builtins.formatting.gofumpt)
      -- table.insert(opts.sources, nls.builtins.formatting.goimports)
      -- table.insert(
      --   opts.sources,
      --   nls.builtins.diagnostics.golangci_lint.with({
      --     args = { "run", "--fix=false", "--out-format", "json", "--path-prefix", "$ROOT" },
      --   })
      -- )
    end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "delve")
        end,
      },
    },
  },
}
