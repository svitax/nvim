return {
  -- add yaml to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "yaml" })
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- "yamlfmt",
        "yamllint",
        -- "yamlls", -- yamlls will be automatically installed with mason and loaded with lspconfig
      }, 0, #opts.ensure_installed)
    end,
  },
  -- { "stevearc/conform.nvim", opts = { formatters_by_ft = { yaml = { "yamlfmt" } } } },
  { "mfussenegger/nvim-lint", opts = { linters_by_ft = { yaml = { "yamllint" } } } },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- "cuducos/yaml.nvim",
      {
        "someone-stole-my-name/yaml-companion.nvim",
        config = function()
          require("telescope").load_extension("yaml_schema")
        end,
      },
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      -- yamlls will be automatically installed with mason and loaded with lspconfig
      servers = {
        ---@type lspconfig.options.yamlls
        yamlls = {
          capabilities = {
            textDocument = {
              foldingRange = {
                lineFoldingOnly = false,
              },
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        yamlls = function(_, opts)
          require("lazyvim.util").lsp.on_attach(function(client, buffer)
            if client.name == "yamlls" then
              vim.keymap.set(
                "n",
                "<leader>ms",
                function()
                  require("yaml-companion").open_ui_select()
                end,
                -- "<cmd>Telescope yaml_schema<cr>",
                { desc = "Switch yaml schema", buffer = buffer }
              )
              -- vim.keymap.set("n", "<leader>mv", "<cmd>YAMLView<cr>", { desc = "Show key/value path", buffer = buffer })
              -- vim.keymap.set(
              --   "n",
              --   "<leader>mp",
              --   "<cmd>YAMLYank +<cr>",
              --   { desc = "Yank key/value path", buffer = buffer }
              -- )
              -- vim.keymap.set("n", "<leader>mk", "<cmd>YAMLYankKey +<cr>", { desc = "Yank key path", buffer = buffer })
              -- vim.keymap.set(
              --   "n",
              --   "<leader>mk",
              --   "<cmd>YAMLYankValue +<cr>",
              --   { desc = "Yank value path", buffer = buffer }
              -- )
              -- vim.keymap.set(
              --   "n",
              --   "<leader>mq",
              --   "<cmd>YAMLQuickfix<cr>",
              --   { desc = "Quickfix with key/values", buffer = buffer }
              -- )
              -- vim.keymap.set(
              --   "n",
              --   "<leader>mf",
              --   "<cmd>YAMLTelescope<cr>",
              --   { desc = "Find key/value paths", buffer = buffer }
              -- )
            end
          end)
          local cfg = require("yaml-companion").setup({
            lspconfig = opts,
            schemas = {
              -- TODO: don't upload work schemas
              -- { name = "TESTSCHEMA", uri = "/home/svitax/.config/nvim/lua/plugins/test_schema.json" },
              { name = "Rio", uri = os.getenv("RIO_SCHEMA_URI") },
            },
          })
          require("lspconfig")["yamlls"].setup(cfg)

          return true
        end,
      },
    },
  },
}
