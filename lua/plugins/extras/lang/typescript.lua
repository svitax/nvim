return {
  -- add typescript to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "typescript", "tsx", "javascript" }, 1, #opts.ensure_installed)
      end
    end,
  },
  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        ---@type lspconfig.options.tsserver
        tsserver = {
          keys = {
            { "<leader>mo", "<cmd>TypescriptOrganizeImports<CR>", desc = "Organize Imports" },
            { "<leader>mR", "<cmd>TypescriptRenameFile<CR>", desc = "Rename File" },
          },
          settings = {
            completions = { completeFunctionCalls = true },
            typescript = {
              -- format = { indentSize = vim.o.shiftwidth, convertTabsToSpaces = vim.o.expandtab, tabSize = vim.o.tabstop },
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              -- format = { indentSize = vim.o.shiftwidth, convertTabsToSpaces = vim.o.expandtab, tabSize = vim.o.tabstop },
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
      },
      setup = {
        tsserver = function(_, opts)
          -- require("lazyvim.util").on_attach(function(client, buffer)
          --   if client.name == "tsserver" then
          --     -- stylua: ignore
          --     vim.keymap.set("n", "<leader>cO", "<cmd>TypescriptOrganizeImports<CR>",
          --       { buffer = buffer, desc = "Organize Imports" })
          --     -- stylua: ignore
          --     vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>",
          --       { desc = "Rename File", buffer = buffer })
          --   end
          -- end)
          require("typescript").setup({ server = opts })
          return true
        end,
      },
    },
  },
  -- Setup typescripts.nvim to lazy load when in a typescript file.
  -- We don't add it as an lspconfig dependency as it will always get loaded with lspconfig.
  -- The lspconfig server settings are added to the opts and used to setup typescript.
  {
    "jose-elias-alvarez/typescript.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    config = function(_, opts)
      -- pull in the lspconfig server settings and use them for typescript setup
      local lsp_opts = require("lazyvim.util").opts("nvim-lspconfig")
      opts.server = lsp_opts.servers.tsserver
      require("typescript").setup(opts)
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "prettierd",
        "eslint_d",
        -- "eslint-lsp",
      }, 0, #opts.ensure_installed)
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      -- table.insert(opts.sources, require("typescript.extensions.null-ls.code-actions"))
      table.insert(opts.sources, nls.builtins.formatting.prettierd.with({ disabled_filetypes = { "yaml" } }))
      table.insert(
        opts.sources,
        nls.builtins.formatting.eslint_d.with({
          -- method = nls.methods.DIAGNOSTICS_ON_SAVE,
          condition = function(utils)
            return utils.root_has_file({
              ".eslintrc.js",
              ".eslintrc.json",
              ".eslintrc.cjs",
              ".eslintrc.ts",
              ".eslintrc.yaml",
              ".eslintrc.yml",
              "eslint.config.js",
            })
          end,
        })
      )
    end,
  },
}
