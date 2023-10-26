return {
  { "neovim/nvim-lspconfig", opts = { servers = { ltex = {} } } },
  { "stevearc/conform.nvim", opts = { formatters_by_ft = { markdown = { "markdownlint" } } } },
  { "mfussenegger/nvim-lint", opts = { linters_by_ft = { markdown = { "markdownlint" } } } },
  {
    "epwalsh/obsidian.nvim",
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/OneDrive/Apps/remotely-save/obsidian-vault/**.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/OneDrive/Apps/remotely-save/obsidian-vault/**.md",
    },
    opts = { dir = "~/OneDrive/Apps/remotely-save/obsidian-vault/", mappings = {} },
    keys = {
      { "<leader>fn", "<cmd>ObsidianQuickSwitch<cr>", desc = "Find notes" },
      { "<leader>nf", "<cmd>ObsidianQuickSwitch<cr>", desc = "Find notes" },
      { "<leader>nN", "<cmd>ObsidianNew<cr>", desc = "New note" },
      -- { "<leader>sn", "<cmd>ObsidianSearch<cr>", desc = "Search in notes" },
      { "<leader>ns", "<cmd>ObsidianSearch<cr>", desc = "Search in notes" },
      { "<leader>nl", "<cmd>ObsidianLink<cr>", desc = "Link selection" },
      { "<leader>nL", "<cmd>ObsidianLinkNew<cr>", desc = "Link selection (new)" },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- "kdheepak/cmp-latex-symbols",
      "amarakon/nvim-cmp-lua-latex-symbols",
      "jc-doyle/cmp-pandoc-references",
    },
    opts = function(_, opts)
      local cmp = require("cmp")

      -- opts.cmp_source_names["otter"] = "(otter)"
      -- opts.cmp_source_names["latex_symbols"] = "(latex)"
      opts.cmp_source_names["lua-latex-symbols"] = "(latex)"
      opts.cmp_source_names["pandoc_references"] = "(ref)"

      cmp.setup.filetype({ "tex", "plaintex", "markdown", "text" }, {
        sources = cmp.config.sources(vim.list_extend(opts.sources, {
          { name = "lua-latex-symbols", group_index = 2, option = { cache = true } },
          { name = "pandoc_references", group_index = 2 },
        })),
      })
    end,
  },
  {
    "nvim-telescope/telescope-bibtex.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("bibtex")
    end,
    keys = {
      -- { "<leader>nb", "<cmd>Telescope bibtex<cr>", desc = "Bibliography" },
      -- { "<leader>nB", "<cmd>e ~/Dropbox/docs/lib.bib<cr>", desc = "Edit bib file" },
      -- { "<leader>nB", "<cmd>e ~/Drive/docs/lib.bib<cr>", desc = "Edit bib file" },
      { "<leader>nB", "<cmd>e ~/OneDrive/docs/lib.bib<cr>", desc = "Edit bib file" },
      {
        "<leader>fb",
        function()
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")
          -- local Path = require("plenary.path")
          local Job = require("plenary.job")
          require("telescope._extensions.bibtex").exports.bibtex({
            attach_mappings = function(prompt_bufnr, map)
              require("telescope.actions").select_default:replace(function()
                local entry = action_state.get_selected_entry().id.content
                -- print(vim.inspect(action_state.get_selected_entry()))
                local cmd = vim.fn.has("win32") == 1 and "start" or vim.fn.has("mac") == 1 and "open" or "xdg-open"
                for _, line in pairs(entry) do
                  local match_base = "%f[%w]file"
                  local s = line:match(match_base .. "%s*=%s*%b{}")
                    or line:match(match_base .. '%s*=%s*%b""')
                    or line:match(match_base .. "%s*=%s*%d+")
                    or line:match("%s*books/[^\n]+")
                  if s ~= nil then
                    -- s = s:match("%b{}") or s:match('%b""') or s:match("%d+")
                    -- s = "/home/svitax/Dropbox/docs/" .. (s:match("%{(.-)%}") or s:match("(books/[^\n]+)"))
                    -- s = "/home/svitax/Drive/docs/" .. (s:match("%{(.-)%}") or s:match("(books/[^\n]+)"))
                    s = "/home/svitax/OneDrive/docs/" .. (s:match("%{(.-)%}") or s:match("(books/[^\n]+)"))
                    -- print(s)
                    Job:new({
                      command = cmd,
                      args = { s },
                      detached = true,
                    }):start()
                    break
                  end
                end
                actions.close(prompt_bufnr)
              end)
              return true
            end,
          })
        end,
        desc = "Bibliography",
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- NOTE: installing zk through mason breaks ZkNew functionality
        -- "zk",
        "markdownlint",
        -- "cbfmt",
        -- "codespell",
        -- "vale",
      }, 0, #opts.ensure_installed)
    end,
  },
  -- {
  --   "nvimtools/none-ls.nvim",
  --   opts = function(_, opts)
  --     local nls = require("null-ls")
  --     table.insert(
  --       opts.sources,
  --       nls.builtins.diagnostics.markdownlint.with({
  --         extra_args = { "--disable", "trailing-spaces", "no-multiple-blanks", "line-length" },
  --       })
  --     )
  --     table.insert(
  --       opts.sources,
  --       nls.builtins.formatting.trim_whitespace.with({ filetypes = { "markdown", "text", "quarto", "http" } })
  --     )
  --     table.insert(
  --       opts.sources,
  --       nls.builtins.formatting.trim_newlines.with({ filetypes = { "markdown", "text", "quarto", "http" } })
  --     )
  --     -- table.insert(opts.sources, nls.builtins.formatting.bibclean)
  --     -- table.insert(opts.sources, nls.builtins.formatting.mdformat)
  --     -- table.insert(opts.sources, nls.builtins.formatting.cbfmt)
  --     -- table.insert(opts.sources, nls.builtins.diagnostics.codespell.with({ filetypes = { "text", "markdown" } }))
  --     -- table.insert(
  --     --   opts.sources,
  --     --   nls.builtins.diagnostics.vale.with({
  --     --     extra_args = { "--config", vim.fn.expand("$HOME") .. "/.config/vale/.vale.ini" },
  --     --     diagnostics_postprocess = function(diagnostic)
  --     --      diagnostic.severity = vim.diagnostic.severity.HINT
  --     --    end
  --     --   })
  --     -- )
  --     -- table.insert(
  --     --   opts.sources,
  --     --   nls.builtins.formatting.markdownlint.with({
  --     --     extra_args = { "--disable", "trailing-spaces", "no-multiple-blanks", "line-length" },
  --     --   })
  --     -- )
  --   end,
  -- },
  -- { "opdavies/toggle-checkbox.nvim", ft = { "markdown" } },
  -- {
  --   "quarto-dev/quarto-nvim",
  --   dev = false,
  --   dependencies = {
  --     {
  --       "jmbuhr/otter.nvim",
  --       dev = false,
  --       config = function()
  --         require("otter").setup({})
  --       end,
  --     },
  --   },
  --   ft = { "quarto", "markdown" },
  --   config = function()
  --     require("quarto").setup({
  --       lspFeatures = {
  --         enabled = true,
  --         languages = { "r", "python", "julia", "bash", "lua" },
  --         chunks = "curly", -- 'curly' or 'all'
  --         diagnostics = { enabled = true, triggers = { "BufWritePost" } },
  --         completion = { enabled = true },
  --       },
  --       keymap = { hover = "K", definition = "gd" },
  --     })
  --     vim.keymap.set("n", "<leader>nQ", "<cmd>QuartoActivate<cr>", { desc = "Quarto activate" })
  --   end,
  -- },
}
