return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        -- "luacheck",
      }, 0, #opts.ensure_installed)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      lua_ls = {
        settings = { Lua = { workspace = { checkThirdParty = false }, completion = { callSnippet = "Replace" } } },
      },
    },
  },
  { "stevearc/conform.nvim", opts = { formatters_by_ft = { lua = { "stylua" } } } },
  {
    "mfussenegger/nvim-lint",
    opts = {
      -- linters_by_ft = { lua = { "selene" } },
      -- LazyVim extension to easily override linter options
      -- or add custom linters.
      ---@type table<string,table>
      linters = {
        -- Example of using selene only when a selene.toml file is present
        selene = {
          -- `condition` is another LazyVim extension that allows you to
          -- dynamically enable/disable linters based on the context.
          condition = function(ctx)
            return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
  },
}
