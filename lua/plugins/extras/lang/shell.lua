return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- "mtoohey31/cmp-fish",
      "tamago324/cmp-zsh",
      "bydlw98/cmp-env",
    },
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.cmp_source_names["zsh"] = "(zsh)"
      -- opts.cmp_source_names["fish"] = "(fish)"
      opts.cmp_source_names["env"] = "(env)"

      cmp.setup.filetype({ "sh", "zsh" }, {
        sources = cmp.config.sources(opts.sources, { { name = "env" }, { name = "zsh" } }),
      })

      -- cmp.setup.filetype({ "fish" }, {
      --   sources = cmp.config.sources(opts.sources, { { name = "env" }, { name = "fish", priority = 10 } }),
      -- })

      -- opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
      --   { name = "fish", priority = 10 },
      -- }, 1, #opts.sources))
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "bash",
          -- "fish"
        })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ---@type lspconfig.options.bashls
        bashls = { filetypes = { "sh", "bash", "zsh" } },
      },
    },
  },
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
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sh = { "shfmt", "shellharden" },
        zsh = { "shfmt", "shellharden" },
        bash = { "shfmt", "shellharden" },
        fish = { "fish_indent" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = { linters_by_ft = { sh = { "shellcheck" }, zsh = { "shellcheck" }, bash = { "shellcheck" } } },
  },
}
