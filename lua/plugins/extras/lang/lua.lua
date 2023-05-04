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
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      table.insert(opts.sources, nls.builtins.formatting.stylua)
      table.insert(
        opts.sources,
        nls.builtins.diagnostics.selene.with({
          method = nls.methods.DIAGNOSTICS_ON_SAVE,
          condition = function(utils)
            return utils.root_has_file({ "selene.toml" })
          end,
        })
      )
      -- table.insert(
      --   opts.sources,
      --   nls.builtins.diagnostics.luacheck.with({
      --     condition = function(utils)
      --       return utils.root_has_file({ ".luacheckrc" })
      --     end,
      --   })
      -- )
    end,
  },
}
