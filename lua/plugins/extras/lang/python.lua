return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    cmd = "VenvSelect",
    keys = { { "<leader>pv", "<cmd>VenvSelect<cr>", desc = "Switch venv" } },
    opts = { search = true, name = ".venv" },
  },
  -- {
  --   "AckslD/swenv.nvim",
  --   opts = {
  --     venvs_path = vim.fn.expand("~/.conda/envs"),
  --     -- venvs_path = vim.fn.expand("~/.cache/pypoetry/virtualenvs/"),
  --     post_set_venv = function()
  --       vim.cmd("LspRestart")
  --     end,
  --   },
  --   keys = { { "<leader>pv", "<cmd>lua require('swenv.api').pick_venv()<cr>", desc = "Switch venv" } },
  -- },
  { "raimon49/requirements.txt.vim", event = "BufReadPre requirements*.txt" },
  -- add python to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "python" }, 0, #opts.ensure_installed)
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        ---@type lspconfig.options.pylsp
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pyflakes = { enabled = false },
                mccabe = { enabled = false },
                pycodestyle = {
                  maxLineLength = 99,
                  ignore = {
                    "E226",
                    "E266",
                    "E302",
                    "E303",
                    "E304",
                    "E305",
                    "E402",
                    "C0103",
                    "W0104",
                    "W0621",
                    "W391",
                    "W503",
                    "W504",
                  },
                },
                pydocstyle = { enabled = false },
                autopep8 = { enabled = false },
                yapf = { enbaled = true },
                flake8 = { enabled = false },
                pylint = { enabled = false },
                rope = { enabled = true },
                rope_completion = { enabled = false },
                rope_autoimport = { enabled = false },
                ruff = { enabled = true },
                -- mypy = { enabled = false },
                black = { enbaled = true },
              },
            },
          },
        },
        -- will be automatically installed with mason and loaded with lspconfig
        ---@type lspconfig.options.pyright
        pyright = {
          settings = {
            python = {
              analysis = {
                -- INFO: use mypy for type checking
                typeCheckingMode = "off",
                useLibraryCodeForTypes = true,
                diagnosticSeverityOverrides = {
                  -- reportGeneralTypeIssues = "none",
                  -- reportOptionalMemberAccess = "none",
                  -- reportOptionalSubscript = "none",
                  -- reportPrivateImportUsage = "none",
                  reportUndefinedVariable = "none",
                  reportUnusedImport = "none",
                  reportUnusedVariable = "none",
                  reportMissingTypeStubs = "none",
                },
                autoImportCompletions = false,
              },
            },
          },
        },
        sourcery = { init_options = { token = os.getenv("SOURCERY_TOKEN") } },
        -- ruff_lsp = { init_options = { settings = { args = {}, organizeImports = true, fixAll = true } } },
        -- ruff_lsp = {},
      },
      setup = {
        -- ruff_lsp = function(_, opts)
        --   require("lazyvim.util").on_attach(function(client, buffer)
        --     local rc = client.server_capabilities
        --     if client.name == "ruff_lsp" then
        --       rc.hoverProvider = false
        --     end
        --   end)
        -- end,
        sourcery_lsp = function(_, opts)
          require("lazyvim.util").on_attach(function(client, buffer)
            local rc = client.server_capabilities
            if client.name == "sourcery" then
              rc.hoverProvider = false
            end
          end)
        end,
        pyright = function(_, opts)
          require("lazyvim.util").on_attach(function(client, buffer)
            local rc = client.server_capabilities
            if client.name == "pyright" then
              rc.definitionProvider = false
              rc.completionProvider = false
              rc.signatureHelpProvider = false
            end
          end)
        end,
        pylsp = function(_, opts)
          require("lazyvim.util").on_attach(function(client, buffer)
            local rc = client.server_capabilities
            if client.name == "pylsp" then
              rc.renameProvider = false
              rc.hoverProvider = false
            end
          end)
        end,
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "mypy",
        -- "black",
        -- "ruff",
        -- "usort",
        -- "pylint",
        -- "pydocstyle",
        -- "flake8",
        -- "vulture",
        -- "pylama",
        -- "ruff-lsp", -- installed by including in nvim-lspconfig opts
        -- "pyright", -- installed by including in nvim-lspconfig opts
        -- "sourcery", -- installed by including in nvim-lspconfig opts
      }, 0, #opts.ensure_installed)
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      table.insert(
        opts.sources,
        nls.builtins.diagnostics.mypy.with({ prefer_local = ".venv/bin", extra_args = { "--strict" } })
      )
      -- table.insert(opts.sources, nls.builtins.formatting.black)
      -- TODO: use usort until ruff_lsp supports sorting imports with vim.lsp.buf.format() and not just code actions
      -- table.insert(opts.sources, nls.builtins.formatting.usort)
      -- table.insert(opts.sources, nls.builtins.diagnostics.pydocstyle)
      -- table.insert(opts.sources, nls.builtins.diagnostics.pylint)
    end,
  },
}
