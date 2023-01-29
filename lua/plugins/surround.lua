return {
  {
    "kylechui/nvim-surround",
    opts = {
      highlight = {
        duration = 1000,
      },
      -- I just don't want this to conflict with visual S for leap backward
      keymaps = {
        visual = "gz",
        visual_line = "gZ",
      },
      surrounds = {
        -- markdown link surrounding (uses default register for link)
        ["l"] = {
          add = function()
            local clipboard = vim.fn.getreg("+"):gsub("\n", "")
            return {
              { "[" },
              { "](" .. clipboard .. ")" },
            }
          end,
          find = "%b[]%b()",
          delete = "^(%[)().-(%]%b())()$",
          change = {
            target = "^()()%b[]%((.-)()%)$",
            replacement = function()
              local clipboard = vim.fn.getreg("+"):gsub("\n", "")
              return {
                { "" },
                { clipboard },
              }
            end,
          },
        },
      },
    },
    keys = {
      { "ds", desc = "Delete surrounding" },
      { "ys", desc = "Add surrounding" },
      { "yS", desc = "Add surrounding (newlines) " },
      { "yss", desc = "Add surrounding line" },
      { "ySS", desc = "Add surrounding line (newlines)" },
      { "cs", desc = "Change surrounding" },
      { "gz", mode = { "v" }, desc = "Add surrounding" },
      { "gZ", mode = { "v" }, desc = "Add surrounding (newlines)" },
      { "<c-g>s", mode = { "i" }, desc = "Add surrounding" },
      { "<c-g>S", mode = { "i" }, desc = "Add surrounding (newlines)" },
    },
  },
  -- {
  --   -- TODO: replace mini.surround with nvim-surround
  --   -- add/delete/change surroundings with ys{motion}{char}, ds{char}, and cs{target}{replacement}
  --   "echasnovski/mini.surround",
  --   keys = function(plugin, keys)
  --     -- Populate the keys based on the user's options
  --     local opts = require("lazy.core.plugin").values(plugin, "opts", false)
  --     local mappings = {
  --       { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
  --       { opts.mappings.delete, desc = "Delete surrounding" },
  --       { opts.mappings.find, desc = "Find right surrounding" },
  --       { opts.mappings.find_left, desc = "Find left surrounding" },
  --       { opts.mappings.highlight, desc = "Highlight surrounding" },
  --       { opts.mappings.replace, desc = "Replace surrounding" },
  --       { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
  --     }
  --     return vim.list_extend(mappings, keys, 1, #mappings)
  --   end,
  --   opts = {
  --     mappings = {
  --       add = "ys", -- Add surrounding in Normal and Visual modes
  --       delete = "ds", -- Delete surrounding
  --       highlight = "hs", -- Highlight surrounding
  --       replace = "cs", -- Replace surrounding
  --       -- find = "gzf", -- Find surrounding (to the right)
  --       -- find_left = "gzF", -- Find surrounding (to the left)
  --       -- update_n_lines = "gzn", -- Update `n_lines`
  --     },
  --     search_method = "cover_or_next",
  --   },
  -- },
}
