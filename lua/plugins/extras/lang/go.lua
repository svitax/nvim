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
    -- opts = {},
    setup = {
      gopls = function(_, opts)
        -- workaround for gopls not supporting semanticTokensProvider
        -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
        require("lazyvim.util").lsp.on_attach(function(client, _)
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
  { "stevearc/conform.nvim", opts = { formatters_by_ft = { go = { "gofumpt", "goimports" } } } },
  { "mfussenegger/nvim-lint", opts = { linters_by_ft = { go = { "golangcilint" } } } },
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
