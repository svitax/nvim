return {
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
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-cmdline",
      -- "PaterJason/cmp-conjure",
      "chrisgrieser/cmp-nerdfont",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      -- "hrsh7th/cmp-omni",
      "f3fora/cmp-spell",
      { "abecodes/tabout.nvim", branch = "feature/tabout-md", opts = {} },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        local unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      -- local png_or_markdown_files = function(path)
      --   return string.match(path, ".*%.png") or string.match(path, ".*%.md")
      -- end

      -- local cmp_source_names = {
      opts.cmp_source_names = {
        buffer = "(buffer)",
        cmdline = "(cmd)",
        -- conjure = "(conjure)",
        luasnip = "(snippet)",
        nerdfont = "(nerdfont)",
        nvim_lsp = "(lsp)",
        -- nvim_lsp_document_symbol = "(symbol)",
        path = "(path)",
        spell = "(spell)",
      }

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      cmp.setup.cmdline(":", {
        sources = { { name = "cmdline" }, { name = "path" } },
        formatting = { max_width = 30 },
      })

      cmp.setup.cmdline({ "/", "?", "@" }, {
        -- cmp groups. if we can't find anything in one group, look in the next
        sources = cmp.config.sources({ { name = "nvim_lsp_document_symbol" } }, { { name = "buffer" } }),
        formatting = { max_width = 30 },
      })

      opts.sources = cmp.config.sources(
        -- cmp groups. if we can't find anything in one group, look in the next
        -- NOTE: do I find myself needing the buffer completions a lot? should I put it back in the first group?
        {
          { name = "nvim_lsp", group_index = 1 },
          { name = "luasnip", group_index = 1 },
          { name = "path", option = { trailing_slash = true }, group_index = 1 },
          { name = "nerdfont", group_index = 1 },
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
          -- need to set spell for this to show up
          -- { name = "spell", option = { keep_all_entries = false }, group_index = 2 },
        }
      )
      -- extend the default lazyvim ones
      -- opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
      --   -- { name = "conjure" },
      --   { name = "nerdfont" },
      -- }, 1, #opts.sources))

      -- TODO: vim-dadbod file
      -- cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
      --   sources = cmp.config.sources({ { name = "vim-dadbod-completion" } }),
      -- })

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

          return item
        end,
      }

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
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
  {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { snippet_engine = "luasnip" },
    cmd = { "Neogen" },
    keys = { { "<leader>cg", "<cmd>Neogen<cr>", desc = "Generate doc" } },
  },
}
