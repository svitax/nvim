local u = require("utils")
return {
  {
    "chrisgrieser/nvim-recorder",
    config = true,
    keys = {
      { "q", desc = "Record macro" },
      { "Q", desc = "Play macro" },
      { "<C-q>", desc = "Switch macro slot" },
      { "cq", desc = "Edit macro" },
      { "yg", desc = "Yank macro" },
    },
  },
  -- <A-n> and <A-p> to cycle through yank history (like Emacs 'kill-ring.')
  {
    "gbprod/yanky.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function(_, opts)
      require("yanky").setup(opts)
      require("telescope").load_extension("yank_history")
    end,
    opts = { highlight = { timer = 150 } },
    keys = {
      { "p", "<Plug>(YankyPutAfter)", desc = "Put after" },
      { "P", "<Plug>(YankyPutBefore)", desc = "Put before" },
      -- { "gp", "<Plug>(YankyGPutAfter)", desc = "gput after" },
      -- { "gP", "<Plug>(YankyGPutBefore)", desc = "gput before" },
      { "<A-n>", "<Plug>(YankyCycleForward)", desc = "Cycle kill ring forward" },
      { "<A-p>", "<Plug>(YankyCycleBackward)", desc = "Cycle kill ring backward" },
      { "<leader>sy", "<cmd>Telescope yank_history<cr>", desc = "Yank history" },
    },
  },
  {
    "axelvc/template-string.nvim",
    ft = { "javascript", "typescript", "python", "javascriptreact", "typescriptreact" },
    config = true,
  },
  {
    "Wansmer/binary-swap.nvim",
    dependencies = { "nvim-treesitter" },
    keys = {
      {
        "<A-.>",
        "<cmd>lua require('binary-swap').swap_operands()<cr>",
        mode = { "n", "i" },
        desc = "Swap operands",
      },
      {
        "<A-,>",
        "<cmd>lua require('binary-swap').swap_operands_with_operator()<cr>",
        mode = { "n", "i" },
        desc = "Swap operands and operator",
      },
    },
  },
  {
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
  -- operator for smart duplication of lines and selections
  {
    "smjonas/duplicate.nvim",
    keys = { "yd", "R", { "R", mode = "x" } },
    config = function()
      require("duplicate").setup({
        operator = {
          normal_mode = "yd",
          visual_mode = "R",
          line = "R",
        },
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
            u.contains({ "javascript", "typescript", "javascriptreact", "typescriptreact" }, ft)
            and line:find("^%s*if.+{$")
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
  {
    "gbprod/substitute.nvim",
    event = "BufReadPost",
    dependencies = "gbprod/yanky.nvim",
    opts = {
      on_substitute = function(event)
        require("yanky").init_ring("p", event.register, event.count, event.vmode:match("[vV�]"))
      end,
    },
    config = function(_, opts)
      require("yanky").setup(opts)
      vim.keymap.set("n", "S", "<cmd>lua require('substitute').operator()<cr>", { desc = "Substitute operator" })
      vim.keymap.set("n", "SS", "<cmd>lua require('substitute').line()<cr>", { desc = "Substitute line" })
      vim.keymap.set("n", "Ss", "<cmd>lua require('substitute').eol()<cr>", { desc = "Substitute eol" })
      vim.keymap.set("x", "S", "<cmd>lua require('substitute').visual()<cr>", { desc = "Substitute selection" })
      vim.keymap.set(
        "n",
        "Sx",
        "<cmd>lua require('substitute.exchange').operator()<cr>",
        { desc = "Exchange operator" }
      )
      vim.keymap.set({ "n" }, "SX", "<cmd>lua require('substitute.exchange').line()<cr>", { desc = "Exchange line" })
      vim.keymap.set("x", "Sx", "<cmd>lua require('substitute.exchange').visual()<cr>", { desc = "Exchange selection" })
      vim.keymap.set("n", "Sxc", "<cmd>lua require('substitute.exchange').line()<cr>", { desc = "Cancel exchange" })
    end,
    -- keys = {
    -- { "cx", "<cmd>lua require('substitute').operator()<cr>", desc = "Substitute operator" },
    -- { "cxs", "<cmd>lua require('substitute').line()<cr>", desc = "Substitute line" },
    -- { "cxS", "<cmd>lua require('substitute').eol()<cr>", desc = "Substitute eol" },
    -- { "cX", "<cmd>lua require('substitute.exchange').operator()<cr>", desc = "Exchange operator" },
    -- { "cXx", "<cmd>lua require('substitute.exchange').line()<cr>", desc = "Exchange line" },
    -- { "cXc", "<cmd>lua require('substitute.exchange').line()<cr>", desc = "Cancel exchange" },
    -- },
  },
}
