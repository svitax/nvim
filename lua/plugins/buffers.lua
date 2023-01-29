vim.keymap.set("n", "<leader>bs", "<cmd>up!<cr>", { desc = "Save buffer" })
vim.keymap.set("n", "<c-s>", "<cmd>up!<cr>", { desc = "Save buffer" })

return {
  -- <A-o> and <A-i> to jump to previous and next buffer on jumplist (mirrors <C-o> and <C-i>.)
  {
    "kwkarlwang/bufjump.nvim",
    opts = {},
    keys = {
      { "<A-o>", "<cmd>lua require('bufjump').backward()<cr>", desc = "Jump previous file" },
      { "<A-i>", "<cmd>lua require('bufjump').forward()<cr>", desc = "Jump next file" },
    },
  },
  -- <Space>ba, <Space>bd, <Space>bh, <Space>bo to delete buffers.
  {
    "kazhala/close-buffers.nvim",
    opts = {},
    keys = {
      { "<leader>ba", "<cmd>BDelete all<cr>", desc = "Delete all buffers" },
      { "<leader>bd", "<cmd>BDelete this<cr>", desc = "Delete buffer" },
      { "<leader>bh", "<cmd>BDelete! hidden<cr>", desc = "Delete hidden buffers" },
      { "<leader>bo", "<cmd>BDelete! other<cr>", desc = "Delete other buffers" },
    },
  },
}
