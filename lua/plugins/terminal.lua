local utils = require("utils")

return {
  { "chomosuke/term-edit.nvim", ft = { "toggleterm" }, opts = { prompt_end = "%$ " } },
  -- BUG: my cwd gets stuck whenever I look at a file in my .config/nvim, and none of these autoroot plugins fix it
  -- {
  --   "notjedi/nvim-rooter.lua",
  --   lazy = false,
  --   config = function(_, opts)
  --     require("nvim-rooter").setup(opts)
  --     vim.cmd([[RooterToggle]])
  --   end,
  -- },
  { "ahmedkhalf/project.nvim", name = "project_nvim", lazy = false, config = true },
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
      start_in_insert = true,
      shade_filetypes = { "none" },
      on_create = function(t)
        -- vim.keymap.set(
        --   "n",
        --   "q",
        --   "<cmd>close<cr>",
        --   { buffer = true, noremap = true, silent = true, desc = "Close terminal" }
        -- )
        vim.keymap.set("t", "<c-j>", [[<Cmd>wincmd j<CR>]], { buffer = true, desc = "Switch window down" })
        vim.keymap.set("t", "<c-k>", [[<Cmd>wincmd k<CR>]], { buffer = true, desc = "Switch window up" })
        vim.keymap.set("t", "<c-l>", [[<Cmd>wincmd h<CR>]], { buffer = true, desc = "Switch window left" })
        vim.keymap.set("t", "<c-h>", [[<Cmd>wincmd l<CR>]], { buffer = true, desc = "Switch window right" })
        vim.keymap.set("t", "<ESC>", [[<c-\><c-n>]], { buffer = true, desc = "Exit terminal mode" })
        vim.keymap.set("t", "<C-h>", "<C-w>", { buffer = true, desc = "Delete previous word (<C-bs>)" })
        vim.keymap.set("t", "<C-bs>", "<C-w>", { buffer = true, desc = "Delete previous word (<C-bs>)" })
      end,
    },
    cmd = { "ToggleTerm", "ToggleTermSendVisualSelection" },
    keys = {
      { "<c-t>", "<cmd>ToggleTerm<cr>", mode = { "n", "i", "t" }, desc = "Toggle terminal" },
      { "<A-1>", "<cmd>1ToggleTerm<cr>", mode = { "n", "i", "t" }, desc = "Toggle terminal" },
      { "<A-2>", "<cmd>2ToggleTerm<cr>", mode = { "n", "i", "t" }, desc = "Toggle terminal 2" },
      { "<A-3>", "<cmd>3ToggleTerm<cr>", mode = { "n", "i", "t" }, desc = "Toggle terminal 3" },
      { "<A-4>", "<cmd>4ToggleTerm<cr>", mode = { "n", "i", "t" }, desc = "Toggle terminal 4" },
      { "<A-5>", "<cmd>5ToggleTerm<cr>", mode = { "n", "i", "t" }, desc = "Toggle terminal 5" },
      { "<A-6>", "<cmd>6ToggleTerm<cr>", mode = { "n", "i", "t" }, desc = "Toggle terminal 6" },
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

      -- { "<leader>tt", "<cmd>ToggleTerm direction='horizontal'<cr>", desc = "Toggle terminal" },
      -- { "<leader>tv", "<cmd>ToggleTerm direction='vertical'<cr>", desc = "Toggle terminal vertical" },
    },
  },
  -- {
  --   "airblade/vim-rooter",
  --   init = function()
  --     vim.g["rooter_cd_cmd"] = "lcd"
  --   end,
  --   cmd = { "Rooter" },
  -- },
  -- {
  --   "samjwill/nvim-unception",
  --   init = function()
  --     vim.g.unception_open_buffer_in_new_tab = true
  --   end,
  --   config = function()
  --     vim.api.nvim_create_autocmd("User", {
  --       group = vim.api.nvim_create_augroup("UnceptionGroup", { clear = true }),
  --       pattern = "UnceptionEditRequestReceived",
  --       callback = function()
  --         local ok, _ = pcall(require, "toggleterm")
  --         if ok then
  --           vim.cmd("ToggleTerm")
  --         end
  --       end,
  --     })
  --   end,
  -- },
}
