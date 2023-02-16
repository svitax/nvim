return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- change/add/delete lazyvim lsp keymaps
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<leader>ca", false }
      keys[#keys + 1] = { "<leader>cd", false }
      keys[#keys + 1] = { "<leader>cA", vim.lsp.codelens.run, desc = "Codelens" }
    end,
    opts = {
      autoformat = false,
      diagnostics = {
        virtual_text = false,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
          format = function(d)
            local code = d.code or (d.user_data and d.user_data.lsp.code)
            if code then
              return string.format("%s [%s]", d.message, code):gsub("1. ", "")
            end
            return d.message
          end,
        },
      },
      servers = {
        tailwindcss = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        },
        bashls = { filetypes = { "sh", "zsh", "bash" } },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        -- "editorconfig-checker"
        -- "commitlint",
        -- "beautysh",
        "shfmt",
        "shellharden",
      }, 0, #opts.ensure_installed)
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          -- nls.builtins.diagnostics.xo,
          -- nls.builtins.code_actions.xo,
          -- nls.builtins.formatting.prettierd,
          nls.builtins.formatting.stylua,
          nls.builtins.diagnostics.selene,
          -- nls.builtins.diagnostics.commitlint,
          nls.builtins.diagnostics.zsh,
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.shellharden,
          nls.builtins.formatting.beautysh,
        },
      }
    end,
  },
  {
    "DNLHC/glance.nvim",
    config = true,
    keys = {
      { "<leader>ci", "<cmd>Glance implementations<cr>", desc = "Find implementations" },
      { "<leader>cd", "<cmd>Glance definitions<cr>", desc = "Jump to definition" },
      { "<leader>cD", "<cmd>Glance references<cr>", desc = "Jump to references" },
    },
  },
  -- {
  --   -- TODO: preview doesn't work and won't override lazyvim <leader>ca for some reason
  --   "aznhe21/actions-preview.nvim",
  --   opts = {
  --     diff = {
  --       algorithm = "patience",
  --       ignore_whitespace = true,
  --     },
  --     telescope = require("telescope.themes").get_ivy(),
  --   },
  --   keys = {
  --     { "<leader>ca", "<cmd>lua require('actions-preview').code_actions()<cr>", desc = "Code actions" },
  --     -- { "<leader>ca", desc = "Code actions ()" },
  --   },
  -- },
}
