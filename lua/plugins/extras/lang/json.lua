return {
  {
    "gennaro-tedesco/nvim-jqx",
    ft = { "json", "yaml", "qf" },
    cmd = { "JqxList", "JqxQuery" },
    keys = {
      { "<leader>mjl", "<cmd>JqxList<cr>", desc = "jqx list" },
      { "<leader>mjs", "<cmd>JqxQuery<cr>", desc = "jqx query" },
    },
  },
  -- add json to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "json", "json5", "jsonc" }, 1, #opts.ensure_installed)
      end
    end,
  },
  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/SchemaStore.nvim",
      version = false, -- last release is way too old
    },
    opts = {
      -- make sure mason installs the server
      servers = {
        ---@type lspconfig.options.jsonls
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = { json = { format = { enable = true }, validate = { enable = true } } },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- "fixjson"
        "jsonlint",
      }, 0, #opts.ensure_installed)
    end,
  },
  { "stevearc/conform.nvim", opts = { formatters_by_ft = { json = { "jq" }, jsonc = { "jq" } } } },
  { "mfussenegger/nvim-lint", opts = { linters_by_ft = { json = { "jsonlint" }, jsonc = { "jsonlint" } } } },
}
