return {
  -- TODO: how do I make this work only in tailwind projects?
  {
    "razak17/tailwind-fold.nvim",
    ft = { "html", "svelte", "astro", "vue", "typescriptreact", "javascriptreact" },
    keys = {
      {
        "<leader>cc",
        function()
          if vim.wo.conceallevel > 0 then
            return ":set conceallevel=0<cr>"
          else
            return ":set conceallevel=1<cr>"
          end
        end,
        desc = "Toggle conceal level",
        buffer = true,
        expr = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ---@type lspconfig.options.tailwindcss
        tailwindcss = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
          -- only attach tailwindcss server if there's a tailwind config file
          root_dir = require("lspconfig").util.root_pattern(
            "tailwind.config.js",
            "tailwind.config.ts"
            -- "postcss.config.js",
            -- "postcss.config.ts",
            -- "package.json",
            -- "node_modules",
            -- ".git"
          ),
        },
      },
    },
  },
  {
    "brenoprata10/nvim-highlight-colors",
    opts = function(_, opts)
      opts.enable_tailwind = true
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
      { "jcha0713/cmp-tw2css" },
    },
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.cmp_source_names["cmp-tw2css"] = "(tailwindcss)"

      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "cmp-tw2css" },
      }, 1, #opts.sources))

      -- original formatter
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item)
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
    end,
  },
}
