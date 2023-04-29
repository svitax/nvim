return {
  {
    "kylechui/nvim-surround",
    opts = {
      aliases = { ["b"] = { ")", "]", "}" } },
      highlight = { duration = 1000 },
      -- I just don't want this to conflict with visual S for leap backward
      keymaps = { visual = "gz", visual_line = "gZ" },
      surrounds = {
        -- markdown link surrounding (uses default register for link)
        ["l"] = {
          add = function()
            local clipboard = vim.fn.getreg("+"):gsub("\n", "")
            return { { "[" }, { "](" .. clipboard .. ")" } }
          end,
          find = "%b[]%b()",
          delete = "^(%[)().-(%]%b())()$",
          change = {
            target = "^()()%b[]%((.-)()%)$",
            replacement = function()
              local clipboard = vim.fn.getreg("+"):gsub("\n", "")
              return { { "" }, { clipboard } }
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
}
