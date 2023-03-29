vim.keymap.set("n", "<leader>bs", "<cmd>up!<cr>", { desc = "Save buffer" })
vim.keymap.set("n", "<c-s>", "<cmd>up!<cr>", { desc = "Save buffer" })

return {
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
      { "<leader>bt", "<cmd>GrapplePopup tags<cr>", desc = "Show tagged buffers" },
      { "<leader>bT", "<cmd>GrappleToggle<cr>", desc = "Tag buffer" },
    },
  },
  -- <A-o> and <A-i> to jump to previous and next buffer on jumplist (mirrors <C-o> and <C-i>.)
  -- {
  --   "cbochs/portal.nvim",
  --   opts = {
  --     labels = { "j", "k", "l", ";" },
  --     escape = { ["<esc>"] = true, ["q"] = true },
  --     portal = {
  --       title = { render_empty = false, options = { relative = "editor", width = 60 } },
  --       body = { options = { relative = "editor", width = 60 } },
  --     },
  --   },
  --   keys = {
  --     {
  --       "<A-o>",
  --       function()
  --         local query = require("portal.query").resolve({ "different" })
  --         local jumps = require("portal.jump").search(query, "backward")
  --         require("portal.jump").select(jumps[1])
  --       end,
  --       desc = "Jump previous buffer",
  --     },
  --     {
  --       "<A-i>",
  --       function()
  --         local query = require("portal.query").resolve({ "different" })
  --         local jumps = require("portal.jump").search(query, "forward")
  --         require("portal.jump").select(jumps[1])
  --       end,
  --       desc = "Jump next buffer",
  --     },
  --     {
  --       "<C-o>",
  --       function()
  --         require("portal").jump_backward({ query = { "valid", "valid", "valid" } })
  --       end,
  --     },
  --     {
  --       "<C-i>",
  --       function()
  --         require("portal").jump_forward({ query = { "valid", "valid", "valid" } })
  --       end,
  --     },
  --   },
  -- },
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
