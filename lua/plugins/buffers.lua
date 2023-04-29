vim.keymap.set("n", "<leader>bs", "<cmd>up!<cr>", { desc = "Save buffer" })
vim.keymap.set("n", "<c-s>", "<cmd>up!<cr>", { desc = "Save buffer" })

return {
  -- TODO: show grapple tag buffer number in modeline
  {
    "cbochs/grapple.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "GrapplePopup",
      "GrappleTag",
      "GrappleUntag",
      "GrappleToggle",
      "GrappleSelect",
      "GrappleCycle",
      "GrappleReset",
    },
    config = true,
    keys = {
      { "<A-1>", "<cmd>GrappleSelect key=1<cr>", desc = "Select tag buffer 1" },
      { "<A-2>", "<cmd>GrappleSelect key=2<cr>", desc = "Select tag buffer 2" },
      { "<A-3>", "<cmd>GrappleSelect key=3<cr>", desc = "Select tag buffer 3" },
      { "<A-4>", "<cmd>GrappleSelect key=4<cr>", desc = "Select tag buffer 4" },
      { "<A-5>", "<cmd>GrappleSelect key=5<cr>", desc = "Select tag buffer 5" },
      { "<A-6>", "<cmd>GrappleSelect key=6<cr>", desc = "Select tag buffer 6" },
      { "<leader>bt", "<cmd>GrapplePopup tags<cr>", desc = "Show tagged buffers" },
      { "<leader>bT", "<cmd>GrappleToggle<cr>", desc = "Tag buffer" },
    },
  },
  -- <A-o> and <A-i> to jump to previous and next buffer on jumplist (mirrors <C-o> and <C-i>.)
  {
    "kwkarlwang/bufjump.nvim",
    config = true,
    keys = {
      { "<A-o>", "<cmd>lua require('bufjump').backward()<cr>", desc = "Jump previous file" },
      { "<A-i>", "<cmd>lua require('bufjump').forward()<cr>", desc = "Jump next file" },
    },
  },
  -- <Space>ba, <Space>bd, <Space>bh, <Space>bo to delete buffers.
  {
    "kazhala/close-buffers.nvim",
    config = true,
    keys = {
      { "<leader>ba", "<cmd>BDelete all<cr>", desc = "Delete all buffers" },
      { "<leader>bd", "<cmd>BDelete this<cr>", desc = "Delete buffer" },
      { "<leader>bh", "<cmd>BDelete! hidden<cr>", desc = "Delete hidden buffers" },
      { "<leader>bo", "<cmd>BDelete! other<cr>", desc = "Delete other buffers" },
    },
  },
}
