return {
  { "opdavies/toggle-checkbox.nvim", ft = { "markdown" } },
  {
    "quarto-dev/quarto-nvim",
    dev = false,
    dependencies = {
      {
        "jmbuhr/otter.nvim",
        dev = false,
        config = function()
          require("otter").setup({})
        end,
      },
    },
    ft = { "quarto", "markdown" },
    config = function()
      require("quarto").setup({
        lspFeatures = {
          enabled = true,
          languages = { "r", "python", "julia", "bash", "lua" },
          chunks = "curly", -- 'curly' or 'all'
          diagnostics = { enabled = true, triggers = { "BufWritePost" } },
          completion = { enabled = true },
        },
        keymap = { hover = "K", definition = "gd" },
      })
      vim.keymap.set("n", "<leader>nQ", "<cmd>QuartoActivate<cr>", { desc = "Quarto activate" })
    end,
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

      opts.cmp_source_names["otter"] = "(otter)"
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
    "mickael-menu/zk-nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    name = "zk",
    -- ft = "markdown",
    cmd = { "ZkNew", "ZkNotes", "ZkTags", "ZkMatch" },
    opts = { picker = "telescope", lsp = { auto_attach = { filetypes = { "markdown", "quarto" } } } },
    keys = {
      -- Find notes.
      { "<leader>fn", "<cmd>ZkNotes { sort = {'modified'}}<cr>", desc = "Find notes" },
      { "<leader>nn", "<cmd>ZkNotes { sort = {'modified'}}<cr>", desc = "Find notes" },
      -- Search for the notes matching the current visual selection.
      { "<leader>nF", "<cmd><,'>ZkMatch<cr>", mode = "v", desc = "Find note (selection)" },
      -- "Refresh zk index"
      { "<leader>ni", "<cmd>ZkIndex<cr>", desc = "Refresh index" },
      -- Create a new note after asking for its title.
      { "<leader>nN", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", desc = "New note", silent = false },
      -- Create a new Quarto note after asking for its title.
      {
        "<leader>nq",
        function()
          local temp_title = vim.fn.input("Title: ")
          -- local temp_template = vim.ui.select(
          --   vim.fn.systemlist("ls -A $ZK_NOTEBOOK_DIR/.zk/templates/"),
          --   { prompt = "Select template: " },
          --   function(choice)
          --     return choice
          --   end
          -- )
          -- local temp_usertags = vim.fn.input("Additional Tags: ")
          require("zk").new({
            dir = vim.fn.expand("$ZK_NOTEBOOK_DIR/quarto"),
            group = "quarto",
            title = temp_title,
            -- template = temp_template,
            -- extra = { ["user-tags"] = temp_usertags },
          })
        end,
        desc = "New quarto note",
        silent = false,
      },
      {
        "<leader>nj",
        function()
          require("zk").new({
            dir = vim.fn.expand("$ZK_NOTEBOOK_DIR/journal"),
            group = "journal",
            extra = { ["user-tags"] = "journal" },
            -- template = temp_template,
            -- extra = { ["user-tags"] = temp_usertags },
          })
        end,
        desc = "New journal note",
        silent = false,
      },
      -- Open notes linked by the current buffer.
      { "<leader>nl", "<cmd>ZkLinks<cr>", desc = "Find links" },
      -- Open notes linking to the current buffer.
      { "<leader>nL", "<cmd>ZkBacklinks<cr>", desc = "Find backlinks" },
      -- Open notes associated with the selected tag.
      { "<leader>ng", "<cmd>ZkTags<cr>", desc = "Find tags" },
      -- Create a new note in the same directory as the current buffer, using the current selection for title.
      {
        "<leader>nT",
        ":'<,'>ZkNewFromTitleSelection<CR>",
        mode = "v",
        desc = "New note with selection as title",
      },
      -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
      {
        "<leader>nC",
        ":'<,'>ZkNewFromContentSelection { title = vim.fn.input('Title: ') }<CR>",
        mode = "v",
        desc = "New note with selection as content",
      },
    },
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
    "gaoDean/autolist.nvim",
    ft = { "markdown", "text", "tex", "plaintex" },
    config = function()
      local autolist = require("autolist")
      autolist.setup()
      vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
      vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")
      vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
      vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>")
      vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")
      vim.keymap.set("n", "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>")
      vim.keymap.set("n", "<A-r>", "<cmd>AutolistRecalculate<cr>")

      -- cycle list types with dot-repeat
      vim.keymap.set("n", "<leader>ncn", require("autolist").cycle_next_dr, { expr = true })
      vim.keymap.set("n", "<leader>ncp", require("autolist").cycle_prev_dr, { expr = true })

      -- if you don't want dot-repeat
      -- vim.keymap.set("n", "<leader>cn", "<cmd>AutolistCycleNext<cr>")
      -- vim.keymap.set("n", "<leader>cp", "<cmd>AutolistCycleNext<cr>")

      -- functions to recalculate list on edit
      vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
      vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
      vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>")
      vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>")

      -- autolist.create_mapping_hook("i", "<CR>", autolist.new)
      -- autolist.create_mapping_hook("i", "<Tab>", autolist.indent)
      -- autolist.create_mapping_hook("i", "<S-Tab>", autolist.indent, "<C-D>")
      -- autolist.create_mapping_hook("n", "o", autolist.new)
      -- autolist.create_mapping_hook("n", "O", autolist.new_before)
      -- autolist.create_mapping_hook("n", ">>", autolist.indent)
      -- autolist.create_mapping_hook("n", "<<", autolist.indent)
      -- autolist.create_mapping_hook("n", "<C-r>", autolist.force_recalculate)
      -- autolist.create_mapping_hook("n", "<leader>x", autolist.invert_entry, "")

      -- TODO: autolist has a bug where it adds a space to the end of new list items
      -- this autocmd (from the readme) makes it so I can't auto-format that away
      -- vim.api.nvim_create_autocmd("TextChanged", {
      --   pattern = "*",
      --   callback = function()
      --     vim.cmd.normal({ autolist.force_recalculate(nil, nil), bang = false })
      --   end,
      -- })
    end,
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
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      table.insert(
        opts.sources,
        nls.builtins.diagnostics.markdownlint.with({
          extra_args = { "--disable", "trailing-spaces", "no-multiple-blanks", "line-length" },
        })
      )
      -- table.insert(opts.sources, nls.builtins.formatting.cbfmt)
      -- table.insert(opts.sources, nls.builtins.diagnostics.codespell.with({ filetypes = { "text", "markdown" } }))
      -- table.insert(
      --   opts.sources,
      --   nls.builtins.diagnostics.vale.with({
      --     extra_args = { "--config", vim.fn.expand("$HOME") .. "/.config/vale/.vale.ini" },
      --     diagnostics_postprocess = function(diagnostic)
      --      diagnostic.severity = vim.diagnostic.severity.HINT
      --    end
      --   })
      -- )
      -- table.insert(
      --   opts.sources,
      --   nls.builtins.formatting.markdownlint.with({
      --     extra_args = { "--disable", "trailing-spaces", "no-multiple-blanks", "line-length" },
      --   })
      -- )
    end,
  },
  -- BUG: doesn't detect markdown treesitter parser
  -- {
  --   "lukas-reineke/headlines.nvim",
  --   dependencies = "nvim-treesitter/nvim-treesitter",
  --   ft = { "markdown" },
  --   opts = {
  --     markdown = {
  --       query = vim.treesitter.query.parse(
  --         "markdown",
  --         [[
  --                           (atx_heading [
  --                               (atx_h1_marker)
  --                               (atx_h2_marker)
  --                               (atx_h3_marker)
  --                               (atx_h4_marker)
  --                               (atx_h5_marker)
  --                               (atx_h6_marker)
  --                           ] @headline)
  --
  --                           (thematic_break) @dash
  --
  --                           (fenced_code_block) @codeblock
  --
  --                           (block_quote_marker) @quote
  --                           (block_quote (paragraph (inline (block_continuation) @quote)))
  --                       ]]
  --       ),
  --       headline_highlights = {
  --         "Headline1",
  --         "Headline2",
  --         "Headline3",
  --         "Headline4",
  --         "Headline5",
  --         "Headline6",
  --       },
  --       codeblock_highlight = "CodeBlock",
  --       dash_highlight = "Dash",
  --       dash_string = "-",
  --       quote_highlight = "Quote",
  --       quote_string = "┃",
  --       fat_headlines = true,
  --       fat_headline_upper_string = "▃",
  --       fat_headline_lower_string = "🬂",
  --     },
  --   },
  --   config = function(_, opts)
  --     require("headlines").setup(opts)
  --     vim.api.nvim_set_hl(0, "Headline1", { fg = "#cb7676", bg = "#402626", italic = false })
  --     vim.api.nvim_set_hl(0, "Headline2", { fg = "#c99076", bg = "#66493c", italic = false })
  --     vim.api.nvim_set_hl(0, "Headline3", { fg = "#80a665", bg = "#3d4f2f", italic = false })
  --     vim.api.nvim_set_hl(0, "Headline4", { fg = "#4c9a91", bg = "#224541", italic = false })
  --     vim.api.nvim_set_hl(0, "Headline5", { fg = "#6893bf", bg = "#2b3d4f", italic = false })
  --     vim.api.nvim_set_hl(0, "Headline6", { fg = "#d3869b", bg = "#6b454f", italic = false })
  --     vim.api.nvim_set_hl(0, "CodeBlock", { bg = "#444444" })
  --   end,
  -- },
}
