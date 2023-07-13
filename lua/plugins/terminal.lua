local utils = require("utils")

return {
  -- NOTE: I need this for overseer to work properly
  -- { "ahmedkhalf/project.nvim", name = "project_nvim", lazy = false, config = true },
  -- { "notjedi/nvim-rooter.lua", event = "VeryLazy", config = true },
  {
    "chomosuke/term-edit.nvim",
    ft = { "toggleterm", "ugaterm" },
    opts = {
      -- prompt_end = "%$ " -- bash/zsh
      prompt_end = "> ", -- powershell/fish
    },
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {
      open_mapping = [[<c-t>]],
      -- autochdir = true,
      size = function(term)
        if term.direction == "horizontal" then
          return math.floor(vim.opt.lines:get() * 0.25)
        elseif term.direction == "vertical" then
          return math.floor(vim.opt.columns:get() * 0.25)
        end
      end,
      direction = "horizontal",
      insert_mappings = false,
      terminal_mappings = true,
      start_in_insert = true,
      shade_filetypes = { "none" },
      on_create = function(t)
        vim.keymap.set("n", "q", "<cmd>ToggleTerm<cr>", { buffer = true, silent = true })
        vim.keymap.set("t", "<c-j>", [[<Cmd>wincmd j<CR>]], { buffer = true, desc = "Switch window down" })
        vim.keymap.set("t", "<c-k>", [[<Cmd>wincmd k<CR>]], { buffer = true, desc = "Switch window up" })
        vim.keymap.set("t", "<c-l>", [[<Cmd>wincmd h<CR>]], { buffer = true, desc = "Switch window left" })
        vim.keymap.set("t", "<c-h>", [[<Cmd>wincmd l<CR>]], { buffer = true, desc = "Switch window right" })
        vim.keymap.set("t", "<ESC>", [[<c-\><c-n>]], { buffer = true, desc = "Exit terminal mode" })
        vim.keymap.set("t", "<C-h>", "<C-w>", { buffer = true, desc = "Delete previous word (<C-bs>)" })
        vim.keymap.set("t", "<C-bs>", "<C-w>", { buffer = true, desc = "Delete previous word (<C-bs>)" })
        -- vim.keymap.set("t", "<C-h>", "<C-\\><C-o>db", { buffer = true, desc = "Delete previous word (<C-bs>)" })
        -- vim.keymap.set("t", "<C-bs>", "<C-\\><C-o>db", { buffer = true, desc = "Delete previous word (<C-bs>)" })
      end,
    },
    cmd = {
      "ToggleTerm",
      "ToggleTermSendCurrentLine",
      "ToggleTermSendVisualLines",
      "ToggleTermSendVisualSelection",
      "ToggleTermToggleAll",
      "ToggleTermSetName",
      "TermSelect",
      "TermExec",
    },
    keys = {
      -- { "<C-t>", "<cmd>ToggleTerm<cr>", mode = { "n", "i", "t" }, desc = "Toggle terminal" },
      { "<C-t>", desc = "Toggle terminal" },
      { "<C-1>", "<cmd>1ToggleTerm<cr>", mode = { "n", "i", "t" }, desc = "Toggle terminal" },
      { "<C-2>", "<cmd>2ToggleTerm<cr>", mode = { "n", "i", "t" }, desc = "Toggle terminal 2" },
      { "<C-3>", "<cmd>3ToggleTerm<cr>", mode = { "n", "i", "t" }, desc = "Toggle terminal 3" },
      { "<C-4>", "<cmd>4ToggleTerm<cr>", mode = { "n", "i", "t" }, desc = "Toggle terminal 4" },
      { "<C-5>", "<cmd>5ToggleTerm<cr>", mode = { "n", "i", "t" }, desc = "Toggle terminal 5" },
      { "<C-6>", "<cmd>6ToggleTerm<cr>", mode = { "n", "i", "t" }, desc = "Toggle terminal 6" },
      { "<C-7>", "<cmd>6ToggleTerm<cr>", mode = { "n", "i", "t" }, desc = "Toggle terminal 7" },
      { "<C-8>", "<cmd>6ToggleTerm<cr>", mode = { "n", "i", "t" }, desc = "Toggle terminal 8" },
      { "<C-9>", "<cmd>6ToggleTerm<cr>", mode = { "n", "i", "t" }, desc = "Toggle terminal 9" },
      { "<leader>ft", "<cmd>TermSelect<cr>", desc = "Find terminal" },
      { "<A-t>", "<cmd>ToggleTermSetName<cr>", desc = "Rename terminal" },
      -- { "<leader>gt", "<cmd>lua _lazygit_toggle()<CR>", mode = { "n" }, desc = "Toggle lazygit" },
      -- { "<leader>hn", "<cmd>lua _navi_toggle()<CR>", mode = { "n" }, desc = "Toggle navi" },
      { "<leader>hn", utils.float_term("navi", { count = 7 }), mode = { "n" }, desc = "Cheatsheet (navi)" },
      { "<leader>ht", utils.float_term("btop", { count = 8 }), mode = { "n" }, desc = "Resource monitor (btop)" },
      { "<leader>gu", utils.float_term("ugit", { count = 9 }), mode = { "n" }, desc = "Undo git commands (ugit)" },
      { "<leader>ga", utils.float_term("git-absorb", { count = 10 }), mode = { "n" }, desc = "git-absorb" },
      {
        "<leader>gD",
        utils.float_term("gh poi --dry-run", { count = 11 }),
        mode = { "n" },
        desc = "Clean branches (poi)",
      },
      { "<leader>pt", "<cmd>TermSelect<cr>", desc = "Find terminal" },
      { "<leader>pT", "<cmd>ToggleTermSetName<cr>", desc = "Rename terminal" },
      -- { "<leader>tt", "<cmd>ToggleTerm direction='horizontal'<cr>", desc = "Toggle terminal" },
      -- { "<leader>tv", "<cmd>ToggleTerm direction='vertical'<cr>", desc = "Toggle terminal vertical" },
    },
  },
  {
    "willothy/flatten.nvim",
    lazy = false,
    priority = 1001,
    opts = {
      window = { open = "alternate" },
      callbacks = {
        pre_open = function()
          require("toggleterm").toggle(0) -- Close toggleterm when an external open request is received
        end,
        post_open = function(bufnr, winnr, ft)
          if ft == "gitcommit" then
            -- If the file is a git commit, create one-shot autocmd to delete it on write
            -- If you just want the toggleable terminal integration, ignore this bit and only use the
            -- code in the else block
            vim.api.nvim_create_autocmd("BufWritePost", {
              buffer = bufnr,
              once = true,
              callback = function()
                -- This is a bit of a hack, but if you run bufdelete immediately
                -- the shell can occasionally freeze
                vim.defer_fn(function()
                  vim.api.nvim_buf_delete(bufnr, {})
                end, 50)
              end,
            })
          else
            -- If it's a normal file, then reopen the terminal, then switch back to the newly opened window
            -- This gives the appearance of the window opening independently of the terminal
            require("toggleterm").toggle(0)
            vim.api.nvim_set_current_win(winnr)
          end
        end,
        block_end = function()
          require("toggleterm").toggle(0) -- After blocking ends (for a git commit, etc), reopen the terminal
        end,
      },
    },
  },
}
