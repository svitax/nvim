return {
  {
    "kylechui/nvim-surround",
    opts = {
      aliases = {
        ["b"] = { ")", "]", "}" },
        ["c"] = "}", -- [c]urly brace
        ["r"] = "]", -- [r]ectangular bracket
        ["e"] = "`", -- t[e]mplate string
      },
      highlight = { duration = 1000 },
      -- I just don't want this to conflict with visual S for leap backward
      keymaps = { visual = "gz", visual_line = "gZ" },
      surrounds = {
        ["*"] = {
          find = "%*.-%*",
          add = { "*", "*" },
          delete = "(%*)().-(%*)()",
          change = {
            target = "(%*)().-(%*)()",
          },
        },
        ["/"] = {
          find = "/.-/",
          add = { "/", "/" },
          delete = "(/)().-(/)()",
          change = {
            target = "(/)().-(/)()",
          },
        },
        -- dunder
        ["__"] = {
          find = "__.-__",
          add = { "__", "__" },
          delete = "(__)().-(__)()",
          change = {
            target = "(__)().-(__)()",
          },
        },
        -- double square bracket
        ["R"] = {
          find = "%[%[.-%]%]",
          add = { "[[", "]]" },
          delete = "(%[%[)().-(%]%])()",
          change = {
            target = "(%[%[)().-(%]%])()",
          },
        },
        -- function
        ["f"] = {
          find = function()
            return require("nvim-surround.config").get_selection({ motion = "a" .. "f" })
          end,
          delete = function()
            local ft = vim.bo.filetype
            local patt
            -- TODO: nvim-surround function pattern for python? ew regex for python
            if ft == "lua" then
              patt = "^(.-function.-%b() ?)().-( ?end)()$"
            elseif ft == "javascript" or ft == "typescript" or ft == "bash" or ft == "zsh" or ft == "sh" then
              patt = "^(.-function.-%b() ?{)().*(})()$"
            else
              vim.notify("No function-surround defined for " .. ft, vim.log.levels.WARN)
              patt = "()()()()"
            end
            return require("nvim-surround.config").get_selections({
              char = "f",
              pattern = patt,
            })
          end,
          add = function()
            local ft = vim.bo.filetype
            if ft == "lua" then
              -- function as one line
              return { { "function() " }, { " end" } }
            elseif ft == "typescript" or ft == "javascript" or ft == "bash" or ft == "zsh" or ft == "sh" then
              -- function on surrounding lines
              return {
                { "function () {", "\t" },
                { "", "}" },
              }
            end
            vim.notify("No function-surround defined for " .. ft, vim.log.levels.WARN)
            return { { "" }, { "" } }
          end,
        },
        -- call
        ["L"] = {
          find = function()
            return require("nvim-surround.config").get_selection({ motion = "a" .. "L" })
          end,
          delete = "^([^=%s]+%()().-(%))()$", -- https://github.com/kylechui/nvim-surround/blob/main/doc/nvim-surround.txt#L357
        },
        -- conditional
        ["o"] = {
          find = function()
            return require("nvim-surround.config").get_selection({ motion = "a" .. "o" })
          end,
          delete = function()
            local ft = vim.bo.filetype
            local patt
            if ft == "lua" then
              patt = "^(if .- then)().-( ?end)()$"
            elseif ft == "javascript" or ft == "typescript" then
              patt = "^(if %b() ?{?)().-( ?}?)()$"
            else
              vim.notify("No conditional-surround defined for " .. ft, vim.log.levels.WARN)
              patt = "()()()()"
            end
            return require("nvim-surround.config").get_selections({
              char = "o",
              pattern = patt,
            })
          end,
          add = function()
            local ft = vim.bo.filetype
            if ft == "lua" then
              return {
                { "if true then", "\t" },
                { "", "end" },
              }
            elseif ft == "typescript" or ft == "javascript" then
              return {
                { "if (true) {", "\t" },
                { "", "}" },
              }
            end
            vim.notify("No if-surround defined for " .. ft, vim.log.levels.WARN)
            return { { "" }, { "" } }
          end,
        },
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
      { "yS", desc = "Add surrounding (newlines)" },
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
