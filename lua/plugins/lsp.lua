return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- change/add/delete lazyvim lsp keymaps
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<leader>cd", false }
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
          filetypes = {
            "javascript",
            "javascriptreact",
          },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- TODO: use xo instead of eslint and prettier
        -- "xo",
        "prettierd",
        "eslint-lsp",
        "css-lsp",
        "cssmodules-language-server",
        -- "stylelint-lsp",
        "tailwindcss-language-server",
        "stylua",
        "selene",
        -- "yamlfmt"
        -- "yamllint"
        -- "bash-language-server"
        -- "commitlint"
        -- "editorconfig-checker"
        -- "fixjson"
        -- "jsonlint"
        "commitlint",
      }, 0, #opts.ensure_installed)
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          nls.builtins.formatting.prettierd,
          nls.builtins.formatting.stylua,
          nls.builtins.diagnostics.selene,
          nls.builtins.diagnostics.commitlint,
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
}
