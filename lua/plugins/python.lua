return {
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
        -- sourcery will be automatically installed with mason and loaded with lspconfig
        sourcery = {
          init_options = {
            token = os.getenv("SOURCERY_TOKEN"),
          },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "pyright",
        "black",
        "ruff-lsp",
        "sourcery",
        "pydocstyle",
        -- "vulture",
        -- "mypy",
        -- "pylama",
      }, 0, #opts.ensure_installed)
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      table.insert(opts.sources, nls.builtins.formatting.black)
      table.insert(opts.sources, nls.builtins.diagnostics.pydocstyle)
    end,
  },
  {
    "AckslD/swenv.nvim",
    opts = {
      venvs_path = vim.fn.expand("~/.conda/envs"),
      post_set_venv = function()
        vim.cmd("LspRestart")
      end,
    },
    keys = {
      { "<leader>pv", "<cmd>lua require('swenv.api').pick_venv()<cr>", desc = "Switch venv" },
    },
  },
}
