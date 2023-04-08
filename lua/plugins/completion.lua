return {
  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = "./snippets" })
      require("luasnip.loaders.from_lua").lazy_load({ paths = "./snippets/luasnippets" })
    end,
  },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- "hrsh7th/cmp-omni",
      -- "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-cmdline",
      -- "PaterJason/cmp-conjure",
      "chrisgrieser/cmp-nerdfont",
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
        -- nvim_lsp_document_symbol = "(symbol)",
        nvim_lsp = "(lsp)",
        buffer = "(buffer)",
        path = "(path)",
        luasnip = "(snippet)",
        -- conjure = "(conjure)",
        nerdfont = "(nerdfont)",
      }

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      cmp.setup.cmdline(":", {
        sources = { { name = "cmdline" }, { name = "path" } },
        formatting = { max_width = 30 },
      })

      cmp.setup.cmdline({ "/", "?", "@" }, {
        -- { name = "nvim_lsp_document_symbol" }
        sources = { { name = "buffer" } },
        formatting = { max_width = 30 },
      })

      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        -- { name = "conjure" },
        { name = "nerdfont" },
      }, 1, #opts.sources))

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
          elseif has_words_before() then
            cmp.complete()
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
