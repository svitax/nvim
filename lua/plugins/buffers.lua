vim.keymap.set("n", "<leader>bs", "<cmd>silent up!<cr>", { desc = "Save buffer" })
vim.keymap.set("n", "<c-s>", "<cmd>silent up!<cr>", { desc = "Save buffer" })

return {
  -- {
  --   "folke/which-key.nvim",
  --   optional = true,
  --   opts = { defaults = { ["<leader>t"] = { name = "+test" }, ["<leader>bx"] = { name = "+scratch" } } },
  -- },
  {
    -- Unlist hidden buffers matching specified ignore sources
    "sQVe/bufignore.nvim",
    event = "BufEnter",
    opts = { ignore_sources = { git = true, patterns = { "/%.git/", "/%node_modules/" } } },
  },
  {
    -- Automatically close unedited buffers in bufferlist when it becomes too long
    "axkirillov/hbac.nvim",
    event = "BufEnter",
    opts = { autoclose = true, threshold = 10 },
    keys = {
      { "<leader>bD", "<cmd>Hbac close_unpinned", desc = "Delete unpinned buffers" },
      { "<leader>bp", "<cmd>Hbac toggle_pin", desc = "Pin buffer" },
    },
  },
  {
    -- Persistent file tags within a project scope to provide immediate navigation to important files
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
  {
    -- <A-o> and <A-i> to jump to previous and next buffer on jumplist (mirrors <C-o> and <C-i>.)
    "kwkarlwang/bufjump.nvim",
    config = true,
    keys = {
      { "<A-o>", "<cmd>lua require('bufjump').backward()<cr>", desc = "Jump previous file" },
      { "<A-i>", "<cmd>lua require('bufjump').forward()<cr>", desc = "Jump next file" },
    },
  },
  {
    -- <Space>bd, <Space>bw to delete buffers.
    "famiu/bufdelete.nvim",
    cmd = { "Bdelete", "Bwipeout" },
    keys = {
      { "<leader>bd", "<cmd>Bdelete<cr>", desc = "Delete buffer" },
      { "<leader>bw", "<cmd>Bwipeout<cr>", desc = "Wipeout buffer" },
    },
  },
  -- {
  --   -- Temporary scratch buffers
  --   "m-demare/attempt.nvim",
  --   dependencies = { "nvim-telescope/telescope.nvim" },
  --   config = function(_, opts)
  --     require("attempt").setup(opts)
  --     require("telescope").load_extension("attempt")
  --   end,
  --   keys = {
  --     { "<leader>bxd", "<cmd>lua require('attempt').delete_buf()<cr>", desc = "Delete scratch buffer" },
  --     { "<leader>bxe", "<cmd>lua require('attempt').run()<cr>", desc = "Eval scratch buffer" },
  --     { "<leader>bxf", "<cmd>Telescope attempt<cr>", desc = "Find scratch buffers" },
  --     { "<leader>bxn", "<cmd>lua require('attempt').new_input_ext()<cr>", desc = "New scratch buffer (input)" },
  --     { "<leader>bxN", "<cmd>lua require('attempt').new_select()<cr>", desc = "New scratch buffer (select)" },
  --     { "<leader>bxr", "<cmd>lua require('attempt').rename_buf()<cr>", desc = "Rename scratch buffer" },
  --   },
  -- },
}
