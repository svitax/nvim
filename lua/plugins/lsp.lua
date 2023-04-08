return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- change/add/delete lazyvim lsp keymaps
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<leader>ca", false }
      keys[#keys + 1] = { "<leader>cd", false }
      keys[#keys + 1] = { "<leader>cA", vim.lsp.codelens.run, desc = "Codelens" }
      keys[#keys + 1] = { "gl", vim.diagnostic.open_float, desc = "Line diagnostics" }
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
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        -- "luacheck",
        -- "editorconfig-checker"
        -- "commitlint",
      }, 0, #opts.ensure_installed)
    end,
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(plugin, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end

      local pylsp = require("mason-registry").get_package("python-lsp-server")

      pylsp:on("install:success", function()
        -- Install pylsp plugins...
        vim.schedule(function()
          local install_cmd = {
            vim.fn.expand("~/.local/share/nvim/mason/packages/python-lsp-server/venv/bin/python"),
            "-m",
            "pip",
            "install",
            "python-lsp-black",
            "python-lsp-ruff",
            -- "pylsp-mypy",
            "pylsp-rope",
            "pyls-isort",
          }
          vim.fn.system(install_cmd)
          -- vim.notify("python-lsp-server plugins installed", "info", { title = "mason.nvim" })
        end)
      end)
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
          -- nls.builtins.diagnostics.luacheck,
          -- nls.builtins.diagnostics.commitlint,
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
  --   keys = { { "<leader>ca", ":lua require('actions-preview').code_actions()<cr>", desc = "Lol" } },
  -- },
}
