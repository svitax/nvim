return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      -- change/add/delete lazyvim lsp keymaps
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      keys[#keys + 1] = { "<leader>ca", false, mode = "n" }
      keys[#keys + 1] = {
        "<leader>cb",
        "<cmd>lua require('actions-preview').code_actions()<cr>",
        desc = "Code actions (preview)",
        mode = { "n", "v" },
      }
      keys[#keys + 1] = { "<leader>cd", false, mode = "n" }
      keys[#keys + 1] = {
        "<leader>cf",
        function()
          -- require("lazyvim.plugins.lsp.format").format({ force = true })
          require("conform").format({ bufnr = 0 })
        end,
        mode = "n",
        desc = "Format",
      }

      keys[#keys + 1] = { "<leader>cA", vim.lsp.codelens.run, desc = "Codelens", mode = "n" }
      keys[#keys + 1] = { "gl", vim.diagnostic.open_float, desc = "Line diagnostics", mode = "n" }
      -- keys[#keys + 1] = { "K", require("utils").keyword, desc = "Hover" }
      keys[#keys + 1] =
        { "gr", "<cmd>lua require('glance').open('references')<cr>", desc = "Goto references", mode = "n" }
      keys[#keys + 1] =
        { "gD", "<cmd>lua require('glance').open('definitions')<cr>", desc = "Goto definitions", mode = "n" }
      keys[#keys + 1] =
        { "gi", "<cmd>lua require('glance').open('implementations')<cr>", desc = "Goto implementations", mode = "n" }
      keys[#keys + 1] =
        { "gy", "<cmd>lua require('glance').open('type_definitions')<cr>", desc = "Goto type definitions", mode = "n" }
      keys[#keys + 1] = {
        "gd",
        function()
          -- NOTE: definition-or-references breaks zk markdown links with 1 reference
          -- better to use vim.lsp.buf.definition whenever we have zk attached
          if require("obsidian").util.cursor_on_markdown_link() then
            return "<cmd>ObsidianFollowLink<cr>"
          else
            require("definition-or-references").definition_or_references()
          end
        end,
        desc = "Goto definition or references",
        silent = true,
        noremap = false,
        expr = true,
        -- expr = true,
      }
    end,
    opts = {
      -- if config.autocmds FennecFormat doesn't work, enable LazyVim's autoformat instead
      -- Enabling this means if there are null-ls formatters available only those will format, no other language server will
      -- autoformat = true,
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        inlay_hints = { enabled = true },
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
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cM", "<cmd>Mason<cr>", desc = "Mason" }, { "<leader>cm", false } },
  },
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
    "luckasRanarison/clear-action.nvim",
    event = "LspAttach",
    opts = {
      mappings = { code_action = { "<leader>ca", "Code actions" } },
      signs = {
        position = "right_align",
        -- update_on_insert = true,
        icons = {
          quickfix = "  ",
          refactor = "  ",
          source = "  ",
          combined = "  ",
        },
        highlights = { -- highlight groups
          quickfix = "CodeActionLabel",
          refactor = "CodeActionLabel",
          source = "CodeActionLabel",
          combined = "CodeActionLabel",
          label = "CodeActionLabel",
        },
      },
    },
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
    "KostkaBrukowa/definition-or-references.nvim",
    opts = function(_, opts)
      local function glance_handle_references_response(result)
        require("glance").open("references")
      end
      opts.on_references_result = glance_handle_references_response
      return opts
    end,
  },
  {
    "DNLHC/glance.nvim",
    opts = function(_, opts)
      local actions = require("glance").actions
      opts.theme = { enable = true, mode = "darken" }
      opts.border = {
        enable = true, -- Show window borders. Only horizontal borders allowed
        top_char = "―",
        bottom_char = "―",
      }
      opts.preview_win_opts = { -- Configure preview window options
        cursorline = false,
        number = true,
        wrap = true,
        statuscolumn = "  %=%l  ",
      }
      opts.winbar = { enable = true }
      opts.mappings = {
        list = {
          ["h"] = actions.close_fold,
          ["l"] = actions.open_fold,
          ["<c-h>"] = actions.enter_win("preview"),
        },
        preview = {
          ["q"] = actions.close,
          ["<c-l>"] = actions.enter_win("list"),
        },
      }
      return opts
    end,
    keys = {
      { "<leader>cd", "<cmd>Glance definitions<cr>", desc = "Jump to definition" },
      { "<leader>cm", "<cmd>Glance references<cr>", desc = "Jump to references" },
      { "<leader>cy", "<cmd>Glance type_definitions<cr>", desc = "Jump to type definitions" },
      { "<leader>ci", "<cmd>Glance implementations<cr>", desc = "Find implementations" },
    },
  },
  -- { "VidocqH/lsp-lens.nvim", event = "LspAttach", cmd = { "LspLensOn", "LspLensOff", "LspLensToggle" }, opts = {} },
  -- {
  --   "Wansmer/symbol-usage.nvim",
  --   event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
  --   opts = {
  --     -- vt_position = "textwidth",
  --     -- vt_position = "end_of_line",
  --     vt_position = "above",
  --     request_pending_text = false,
  --     references = { include_declaration = false },
  --     definition = { enabled = true },
  --     implementation = { enabled = true },
  --     ---@type function(symbol: Symbol): string Symbol{ definition = integer|nil, implementation = integer|nil, references = integer|nil }
  --     text_format = function(symbol)
  --       local fragments = {}
  --
  --       if symbol.references then
  --         local num = symbol.references
  --         if num > 0 then
  --           local usage = symbol.references <= 1 and "Reference:" or "References:"
  --           table.insert(fragments, ("%s %s"):format(usage, num))
  --         end
  --       end
  --
  --       if symbol.definition then
  --         table.insert(fragments, "Definitions: " .. symbol.definition)
  --       end
  --
  --       if symbol.implementation then
  --         table.insert(fragments, "Implements: " .. symbol.implementation)
  --       end
  --
  --       return table.concat(fragments, " | ")
  --     end,
  --   },
  -- },
  {
    "dgagn/diagflow.nvim",
    event = { "LspAttach" },
    opts = {
      format = function(diagnostic)
        local code = diagnostic.code or (diagnostic.user_data and diagnostic.user_data.lsp.code)
        if code then
          return string.format("%s [%s]", diagnostic.message, code):gsub("1. ", "")
        end
        return diagnostic.message
      end,
      -- scope = "line",
      scope = "cursor",
      -- NOTE: doesn't entirely work. maybe is fixed in future
      toggle_event = { "InsertEnter" },
      update_event = { "DiagnosticChanged" },
      show_sign = true,
    },
  },
  {
    -- TODO: do I still need lsp-inlayhints.nvim if nvim has builtin inlay hints?
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
}
