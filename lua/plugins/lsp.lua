return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      -- change/add/delete lazyvim lsp keymaps
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      -- keys[#keys + 1] = { "<leader>ca", false, mode = "n" }
      keys[#keys + 1] = {
        "<leader>ca",
        "<cmd>lua require('actions-preview').code_actions()<cr>",
        desc = "Code actions",
        mode = { "n", "v" },
      }
      keys[#keys + 1] = { "<leader>cd", false, mode = "n" }

      keys[#keys + 1] = { "<leader>cA", vim.lsp.codelens.run, desc = "Codelens", mode = "n" }
      keys[#keys + 1] = { "gl", vim.diagnostic.open_float, desc = "Line diagnostics", mode = "n" }
      -- keys[#keys + 1] = { "K", require("utils").keyword, desc = "Hover" }
    end,
    opts = {
      autoformat = true,
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
          -- format = function(d)
          --   local code = d.code or (d.user_data and d.user_data.lsp.code)
          --   if code then
          --     return string.format("%s [%s]", d.message, code):gsub("1. ", "")
          --   end
          --   return d.message
          -- end,
        },
      },
    },
  },
  { "williamboman/mason.nvim", cmd = "Mason", keys = { { "<leader>cM", "<cmd>Mason<cr>", desc = "Mason" } } },
  {
    "adoyle-h/lsp-toggle.nvim",
    event = "LspAttach",
    cmd = { "ToggleLSP", "ToggleNullLSP" },
    keys = {
      { "<leader>ct", "<cmd>ToggleLSP<cr>", desc = "Toggle LSP" },
      { "<leader>cT", "<cmd>ToggleLSP<cr>", desc = "Toggle NullLSP" },
    },
    opts = {},
  },
  {
    "aznhe21/actions-preview.nvim",
    opts = {
      -- diff = { algorithm = "patience", ignore_whitespace = true },
      telescope = require("telescope.themes").get_ivy({
        -- wrap_results = true,
        mappings = {
          i = {
            ["<c-h>"] = function()
              vim.api.nvim_feedkeys(require("utils").termcodes("<c-s-w>"), "i", true)
            end,
            ["<c-j>"] = function(...)
              return require("telescope.actions").move_selection_next(...)
            end,
            ["<c-k>"] = function(...)
              return require("telescope.actions").move_selection_previous(...)
            end,
            ["<c-f>"] = function(...)
              return require("telescope.actions").to_fuzzy_refine(...)
            end,
            ["<C-s>"] = function(...)
              return require("telescope.actions").cycle_previewers_next(...)
            end,
            ["<C-a>"] = function(...)
              return require("telescope.actions").cycle_previewers_prev(...)
            end,
          },
        },
      }),
    },
  },
  {
    "DNLHC/glance.nvim",
    config = true,
    keys = {
      { "<leader>cd", "<cmd>Glance definitions<cr>", desc = "Jump to definition" },
      { "<leader>cm", "<cmd>Glance references<cr>", desc = "Jump to references" },
      { "<leader>cy", "<cmd>Glance type_definitions<cr>", desc = "Jump to type definitions" },
      { "<leader>ci", "<cmd>Glance implementations<cr>", desc = "Find implementations" },
    },
  },
  -- NOTE: nvim-navbuddy
  -- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = {
  --     {
  --       "SmiteshP/nvim-navbuddy",
  --       dependencies = { "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" },
  --       opts = { lsp = { auto_attach = true } },
  --       config = function(_, opts)
  --         local navbuddy = require("nvim-navbuddy")
  --         local actions = require("nvim-navbuddy.actions")
  --         opts.mappings = {
  --           ["l"] = actions.parent(), -- move to left panel
  --           [";"] = actions.children(), -- move to right panel
  --         }
  --         navbuddy.setup(opts)
  --       end,
  --       keys = { { "<leader>co", "<cmd>Navbuddy<cr>", desc = "Symbols outline" } },
  --     },
  --   },
  -- },
  -- {
  --   "hrsh7th/nvim-gtd",
  --   event = { "BufReadPre", "BufNewFile" },
  --   dependencies = "neovim/nvim-lspconfig",
  --   keys = {
  --     {
  --       "gf",
  --       function()
  --         require("gtd").exec({ command = "edit" })
  --       end,
  --       desc = "Go to definition or file",
  --     },
  --   },
  --   ---@type gtd.kit.App.Config.Schema
  --   opts = {
  --     sources = {
  --       { name = "findup" },
  --       {
  --         name = "walk",
  --         root_markers = {
  --           ".git",
  --           ".neoconf.json",
  --           "Makefile",
  --           "tsconfig.json",
  --           "package.json",
  --         },
  --         ignore_patterns = { "/node_modules", "/.git" },
  --       },
  --       { name = "lsp" },
  --     },
  --   },
  -- },
  {
    "lvimuser/lsp-inlayhints.nvim",
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {}),
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client.server_capabilities.inlayHintProvider then
            local inlayhints = require("lsp-inlayhints")
            inlayhints.on_attach(client, args.buf)
            vim.keymap.set("n", "<leader>uH", inlayhints.toggle, { buffer = args.buf, desc = "Toggle inlay hints" })
          end
        end,
      })
    end,
    opts = {},
  },
  -- {
  --   "kosayoda/nvim-lightbulb",
  --   event = { "BufReadPre", "BufNewFile" },
  --   opts = { ignore = { "null-ls" } },
  --   config = function(_, opts)
  --     require("nvim-lightbulb").setup(opts)
  --     vim.api.nvim_create_autocmd("CursorHold", {
  --       group = vim.api.nvim_create_augroup("lightbulb", {}),
  --       callback = function()
  --         require("nvim-lightbulb").update_lightbulb()
  --       end,
  --     })
  --   end,
  -- },
}
