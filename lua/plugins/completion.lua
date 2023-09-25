return {
  {
    -- Annotation generator
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { snippet_engine = "luasnip" },
    cmd = { "Neogen" },
    keys = { { "<leader>cg", "<cmd>Neogen<cr>", desc = "Generate doc" } },
  },
  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
    opts = {
      -- Don't store snippet history for less overhead
      history = false,
      -- Event on which to check for exiting a snippet's region
      region_check_events = "InsertEnter",
      delete_check_events = "InsertLeave",
      ft_func = function()
        return vim.split(vim.bo.filetype, ".", { plain = true })
      end,
    },
    config = function(_, opts)
      require("luasnip").setup(opts)
      require("luasnip.loaders.from_vscode").lazy_load({ paths = "./snippets" })
      require("luasnip.loaders.from_lua").lazy_load({ paths = "./snippets/luasnippets" })
    end,
  },
  -- http.nvim support for codeium
  -- { "jcdickinson/http.nvim", build = "cargo build --workspace --release" },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "FelipeLema/cmp-async-path",
      "hrsh7th/cmp-cmdline",
      -- "dmitmel/cmp-cmdline-history",
      -- { "jcdickinson/codeium.nvim", dependencies = { "jcdickinson/http.nvim" }, config = true },
      -- vim.call('coc#rpc#ready')
      -- "PaterJason/cmp-conjure",
      { "dcampos/cmp-emmet-vim", dependencies = "mattn/emmet-vim" },
      -- "chrisgrieser/cmp-nerdfont",
      -- "hrsh7th/cmp-nvim-lsp-document-symbol",
      -- "hrsh7th/cmp-omni",
      -- "jmbuhr/otter.nvim",
      -- "lukas-reineke/cmp-rg",
      -- "f3fora/cmp-spell",
      -- { "abecodes/tabout.nvim", branch = "feature/tabout-md", opts = {} },
      "lukas-reineke/cmp-under-comparator",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      -- local has_words_before = function()
      --   local unpack = unpack or table.unpack
      --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      --   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      -- end

      -- local png_or_markdown_files = function(path)
      --   return string.match(path, ".*%.png") or string.match(path, ".*%.md")
      -- end

      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      -- local cmp_source_names = {
      opts.cmp_source_names = {
        async_path = "(path)",
        buffer = "(buffer)",
        cmdline = "(cmd)",
        cmdline_history = "(history)",
        -- conjure = "(conjure)",
        emmet_vim = "(emmet)",
        luasnip = "(snippet)",
        -- nerdfont = "(nerdfont)",
        nvim_lsp = "(lsp)",
        -- nvim_lsp_document_symbol = "(symbol)",
        obsidian = "(obsidian)",
        -- path = "(path)",
        -- rg = "(rg)",
        -- spell = "(spell)",
      }

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      -- Insert parens `(` after selecting function or method item
      -- nvim-autopairs only
      -- cmp.event:on(
      --   "confirm_done",
      --   require("nvim-autopairs.completion.cmp").on_confirm_done({
      --     filetypes = {
      --       ruby = false,
      --       ["*"] = {
      --         ["("] = {
      --           kind = { cmp.lsp.CompletionItemKind.Function, cmp.lsp.CompletionItemKind.Method },
      --           handler = require("nvim-autopairs.completion.handlers")["*"],
      --         },
      --       },
      --     },
      --   })
      -- )

      opts.cmdline_sources = {
        -- mapping = cmp.mapping.preset.cmdline(),
        -- cmp groups. if we can't find anything in one group, look in the next
        sources = {
          { name = "cmdline", max_item_count = 30 },
          { name = "async_path", max_item_count = 20 },
          -- { name = "cmdline_history", max_item_count = 10 },
        },
        formatting = { max_width = 30 },
        -- enabled = function()
        --   -- Disable cmp-cmdline-history for AltSubstitute and S commands
        --   -- Set of commands where cmp will be disabled
        --   local disabled = { AltSubstitute = true, S = true }
        --   -- Get first word of cmdline
        --   local cmd = vim.fn.getcmdline():match("%S+")
        --   -- Return true if cmd isn't disabled
        --   -- else call/return cmp.close(), which returns false
        --   return not disabled[cmd] or cmp.close()
        -- end,
      }
      cmp.setup.cmdline(":", opts.cmdline_sources)

      opts.cmdline_search_sources = {
        -- mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          -- { { name = "nvim_lsp_document_symbol" } },
          { { name = "buffer" } }
        ),
        formatting = { max_width = 30 },
      }
      cmp.setup.cmdline({ "/", "?", "@" }, opts.cmdline_search_sources)

      -- opts.sources = cmp.config.sources(vim.list_extend(opts.sources,))
      opts.sources = {
        -- cmp groups. if we can't find anything in one group, look in the next
        -- NOTE: do I find myself needing the buffer completions a lot? should I put it back in the first group?
        { name = "nvim_lsp", group_index = 1 },
        -- { name = "otter", group_index = 1 },
        -- { name = "codeium", group_index = 1 },
        { name = "luasnip", group_index = 1 },
        -- { name = "path", option = { trailing_slash = true }, group_index = 1 },
        { name = "async_path", option = { trailing_slash = true }, group_index = 1 },
        -- { name = "nerdfont", group_index = 2 },
        {
          name = "buffer",
          keyword_length = 4,
          max_item_count = 5, -- only show up to 5 items
          options = {
            get_bufnrs = function()
              return vim.tbl_map(vim.api.nvim_win_get_buf, vim.api.nvim_list_wins())
            end,
          },
          group_index = 2,
        },
        -- {
        --   name = "rg",
        --   keyword_length = 4,
        --   max_item_count = 5,
        --   priority_weight = 60,
        --   option = { additional_arguments = "--smart-case" },
        -- },
        -- need to set spell for this to show up
        -- { name = "spell", option = { keep_all_entries = false }, group_index = 2 },
      }

      -- TODO: vim-dadbod file
      -- cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
      --   sources = cmp.config.sources({ { name = "vim-dadbod-completion" } }),
      -- })

      -- opts.sorting = vim.tbl_extend("force", opts.sorting, { comparator = { require("cmp-under-comparator").under } })

      local custom_comparators = {
        under_comparator = require("cmp-under-comparator").under,
        codeium_prioritize = function(entry1, entry2)
          if entry1.source.name == "codeium" and entry2.source.name ~= "codeium" then
            return true
          elseif entry2.source.name == "codeium" and entry1.source.name ~= "codeium" then
            return false
          end
        end,
      }

      opts.sorting = {
        priority_weight = 2,
        comparators = {
          -- Below is the default comparator list and order for nvim-cmp
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          -- cmp.config.compare.scopes, -- this is commented in nvim-cmp too
          cmp.config.compare.score,
          custom_comparators.codeium_prioritize,
          -- custom_comparators.emmet_prioritize,
          custom_comparators.under_comparator,
          cmp.config.compare.recently_used, ---@diagnostic disable-line: assign-type-mismatch
          cmp.config.compare.locality, ---@diagnostic disable-line: assign-type-mismatch
          cmp.config.compare.kind,
          cmp.config.compare.sort_text, -- this is commented in default nvim-cmp too
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      }

      opts.formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, item)
          local icons = require("lazyvim.config").icons.kinds
          if icons[item.kind] then
            item.kind = icons[item.kind]
            item.menu = opts.cmp_source_names[entry.source.name]
          end

          if entry.source.name == "nvim_lsp" then
            item.menu = "(" .. entry.source.source.client.name .. ")"
          end

          if entry.source.name == "codeium" then
            item.kind = ""
            item.abbr = item.abbr .. "..."
            item.menu = "(codeium)"
          end

          return item
        end,
      }

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        -- ["<C-f>"] = cmp.mapping(cmp.mapping.complete({
        --   config = { sources = cmp.config.sources({ { name = "codeium" } }) },
        -- })),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-j>"] = {
          i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        },
        ["<C-k>"] = {
          i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        },
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.mapping.close()
            vim.api.nvim_feedkeys(t("<CR>"), "n", true)
          else
            fallback()
          end
        end),
        -- ["<CR>"] = vim.api.nvim_feedkeys(t("<C-z>"), "n", true),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- cmp.select_next_item()
            cmp.confirm()
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- they way you will only jump inside the snippet region
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          -- elseif has_words_before() then
          --   fallback()
          --   cmp.complete()
          else
            fallback()
          end
        end, { "i", "s", "c" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          -- if cmp.visible() then
          --   cmp.select_prev_item()
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s", "c" }),
      })
    end,
  },
}
