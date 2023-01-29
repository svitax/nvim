vim.keymap.set("n", "<leader>wd", "<cmd>try | close | catch | endtry<CR>", { desc = "Delete window" })
vim.keymap.set("n", "<leader>wo", "<cmd>try | only | catch | endtry<CR>", { desc = "Delete other windows" })
vim.keymap.set("n", "<leader>ws", "<cmd>split<CR>", { desc = "Split window" })
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Vsplit window" })
return {
  {
    "declancm/windex.nvim",
    opts = { default_keymaps = false },
    keys = {
      -- I have <C-);> mapped to <C-h> on my keyboard since terminals don't recognize <C-;> as an actual thing
      { "<C-l>", "<cmd>lua require('windex').switch_window('left')<cr>", desc = "Switch window left" },
      { "<C-j>", "<cmd>lua require('windex').switch_window('down')<cr>", desc = "Switch window down" },
      { "<C-k>", "<cmd>lua require('windex').switch_window('up')<cr>", desc = "Switch window up" },
      { "<C-h>", "<cmd>lua require('windex').switch_window('right')<cr>", desc = "Switch window right" },

      { "<leader>wl", "<cmd>lua require('windex').switch_window('left')<cr>", desc = "Switch window left" },
      { "<leader>wj", "<cmd>lua require('windex').switch_window('down')<cr>", desc = "Switch window down" },
      { "<leader>wk", "<cmd>lua require('windex').switch_window('up')<cr>", desc = "Switch window up" },
      { "<leader>w;", "<cmd>lua require('windex').switch_window('up')<cr>", desc = "Switch window right" },

      { "<leader>wz", "<cmd>lua require('windex').toggle_maximize()<cr>", desc = "Maximize window" },

      { "<leader>wS", "<cmd>lua require('windex').create_pane('horizontal')<cr>", desc = "Split tmux pane" },
      { "<leader>wV", "<cmd>lua require('windex').create_pane('vertical')<cr>", desc = "Vsplit tmux pane" },
    },
  },
  {
    "sindrets/winshift.nvim",
    opts = {},
    keys = {
      { "<leader>wa", "<cmd>WinShift<cr>", desc = "Shift window mode" },
      { "<leader>wL", "<cmd>WinShift left<cr>", desc = "Shift window left" },
      { "<leader>wJ", "<cmd>WinShift down<cr>", desc = "Shift window down" },
      { "<leader>wK", "<cmd>WinShift up<cr>", desc = "Shift window up" },
      { "<leader>w:", "<cmd>WinShift right<cr>", desc = "Shift window right" },
    },
  },
}
