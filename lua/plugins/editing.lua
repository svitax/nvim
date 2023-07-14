-- stylua: ignore
-- if true then return {} end

local u = require("utils")
return {
  {
    -- Macro manager
    "ecthelionvi/NeoComposer.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    cmd = { "EditMacros", "ClearNeoComposer", "ToggleDelay" },
    keys = {
      { "q", desc = "Toggle record macro" },
      { "Q", desc = "Play macro" },
      { "<C-q>", desc = "Toggle macro menu" },
      { "cq", desc = "Stop macro" },
      { "yg", desc = "Yank macro" },
      { "<C-n>", desc = "Cycle macro forward" },
      { "<C-p>", desc = "Cycle macro backward" },
      { "<Leader>sM", "<cmd>Telescope macros<cr>", desc = "Search macros" },
    },
    opts = { keymaps = { toggle_macro_menu = "<C-q>" } },
    config = function(_, opts)
      require("NeoComposer").setup(opts)
      require("telescope").load_extension("macros")
    end,
  },
  -- {
  --   "chrisgrieser/nvim-recorder",
  --   config = true,
  --   keys = {
  --     { "q", desc = "Record macro" },
  --     { "Q", desc = "Play macro" },
  --     { "<C-q>", desc = "Switch macro slot" },
  --     { "cq", desc = "Edit macro" },
  --     { "yg", desc = "Yank macro" },
  --   },
  -- },
  -- BUG: in neovim 0.9 E5108: Error executing lua: /usr/share/nvim/runtime/lua/vim/treesitter/language.lua:94: no parser for 'typescriptreact' language, see :help treesitter-parsers
  -- {
  --   "axelvc/template-string.nvim",
  --   event = "InsertEnter",
  --   ft = { "javascript", "typescript", "python", "javascriptreact", "typescriptreact", "vue" },
  --   opts = {
  --     filetypes = { "javascript", "typescript", "python", "javascriptreact", "typescriptreact", "vue" },
  --     remove_template_string = true,
  --     restore_quotes = { normal = [[']], jsx = [["]] },
  --   },
  -- },
  {
    -- Split and join blocks of code
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter" },
    event = "BufReadPost",
    opts = { use_default_keymaps = false },
    config = function(_, opts)
      require("treesj").setup(opts)
      local langs = require("treesj.langs")["presets"]
      vim.api.nvim_create_autocmd({ "FileType" }, {
        group = vim.api.nvim_create_augroup("TreesjFallback", { clear = true }),
        pattern = "*",
        -- TODO: if TSJToggle fails, fallback to regular J
        callback = function()
          if langs[vim.bo.filetype] or vim.bo.filetype == "typescriptreact" or vim.bo.filetype == "javascriptreact" then
            vim.keymap.set("n", "J", "<cmd>TSJToggle<cr>", { buffer = true, desc = "Join toggle" })
          end
        end,
      })
    end,
  },
  {
    -- Operator to replace and exchange text
    "gbprod/substitute.nvim",
    event = "BufReadPost",
    -- dependencies = { "gbprod/yanky.nvim" },
    opts = {
      -- on_substitute = function()
      --   require("yanky.integration").substitute()
      -- end,
      -- on_substitute = function(event)
      --   require("yanky").init_ring("p", event.register, event.count, event.vmode:match("[vV�]"))
      -- end,
    },
    config = true,
    keys = {
      { "S", "<cmd>lua require('substitute').operator()<cr>", desc = "Substitute operator" },
      { "SS", "<cmd>lua require('substitute').line()<cr>", desc = "Substitute line" },
      { "Ss", "<cmd>lua require('substitute').eol()<cr>", desc = "Substitute eol" },
      { "S", "<cmd>lua require('substitute').visual()<cr>", mode = { "x" }, desc = "Substitute selection" },
      { "Sx", "<cmd>lua require('substitute.exchange').operator()<cr>", desc = "Exchange operator" },
      { "SX", "<cmd>lua require('substitute.exchange').line()<cr>", desc = "Exchange line" },
      { "Sxc", "<cmd>lua require('substitute.exchange').line()<cr>", desc = "Cancel exchange" },
      { "Sx", "<cmd>lua require('substitute.exchange').visual()<cr>", mode = { "x" }, desc = "Exchange selecion" },
    },
  },
  {
    -- Operator for smart duplication of lines and selections
    "smjonas/duplicate.nvim",
    keys = { "yd", "R", { "R", mode = "x" }, { "R", mode = "v" } },
    config = function()
      require("duplicate").setup({
        operator = { normal_mode = "yd", visual_mode = "R", line = "R" },
        -- selene: allow(high_cyclomatic_complexity)
        transform = function(lines)
          -- transformation for single line duplication
          if #lines > 1 then
            return lines
          end

          local line = lines[1]
          local ft = vim.bo.filetype

          -- smart switching of conditionals
          if ft == "lua" and line:find("^%s*if.+then$") then
            line = line:gsub("^(%s*)if", "%1elseif")
          elseif u.contains({ "bash", "zsh", "sh" }, ft) and line:find("^%s*if.+then$") then
            line = line:gsub("^(%s*)if", "%1elif")
          elseif
            u.contains({
              "javascript",
              "typescript",
              "tsx", --[["javascriptreact", "typescriptreact"]]
            }, ft) and line:find("^%s*if.+{$")
          then
            line = line:gsub("^(%s*)if", "%1} else if")
          -- smart switching of css words
          elseif ft == "css" then
            if line:find("top") then
              line = line:gsub("top", "bottom")
            elseif line:find("bottom") then
              line = line:gsub("bottom", "top")
            elseif line:find("right") then
              line = line:gsub("right", "left")
            elseif line:find("left") then
              line = line:gsub("left", "right")
            elseif line:find("%sheight") then -- %s condition to avoid matching line-height etc
              line = line:gsub("(%s)height", "%1width")
            elseif line:find("%swidth") then -- %s condition to avoid matching border-width etc
              line = line:gsub("(%s)width", "%1height")
            elseif line:find("dark") then
              line = line:gsub("dark", "light")
            elseif line:find("light") then
              line = line:gsub("light", "dark")
            end
          end

          -- increment numbered vars
          local lineHasNumberedVarAssignment, _, num = line:find("(%d+).*=")
          if lineHasNumberedVarAssignment then
            local nextNum = tostring(tonumber(num) + 1)
            line = line:gsub("%d+(.*=)", nextNum .. "%1")
          end

          -- move cursor position
          local lineNum, colNum = unpack(vim.api.nvim_win_get_cursor(0))
          local keyPos, valuePos = line:find(".%w+ ?[:=] ?")
          if valuePos and not (ft == "css") then
            colNum = valuePos
          elseif keyPos and ft == "css" then
            colNum = keyPos
          end
          vim.api.nvim_win_set_cursor(0, { lineNum, colNum })

          return { line } -- return as array, since that's what the plugin expects
        end,
      })
    end,
  },
  -- TODO: Yanky cycle forward/backward doesn't work
  {
    "gbprod/yanky.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    -- event = "BufReadPost",
    opts = {
      ring = { storage = "sqlite", sync_with_numbered_registers = false, cancel_event = "move" },
      system_clipboard = { sync_with_ring = false },
      highlight = { on_put = false, on_yank = false, timer = 150 },
    },
    keys = {
      -- stylua: ignore
      { "<leader>sy", function() require("telescope").extensions.yank_history.yank_history({ }) end, desc = "Search yank history" },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
      { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
      { "<A-n>", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
      { "<A-p>", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
      { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
      { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
    },
    config = function(_, opts)
      require("yanky").setup(opts)
      vim.g.clipboard = {
        name = "xsel_override",
        copy = {
          ["+"] = "xsel --input --clipboard",
          ["*"] = "xsel --input --primary",
        },
        paste = {
          ["+"] = "xsel --output --clipboard",
          ["*"] = "xsel --output --primary",
        },
        cache_enabled = 1,
      }
    end,
  },
}
