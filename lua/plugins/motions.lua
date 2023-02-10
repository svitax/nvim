-- TODO: replace syntax-tree-surfer and tree-climber.nvim with my fork of nvim-treeclimber
return {
  {
    "ggandor/leap.nvim",
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
      vim.keymap.del({ "n", "x", "o" }, "S")
      vim.keymap.set({ "n", "x", "o" }, "s", function()
        require("leap").leap({ target_windows = { vim.fn.win_getid() } })
      end, { desc = "Leap" })
    end,
  },
  {
    "ziontee113/syntax-tree-surfer",
    config = true,
    dependencies = { "nvim-treesitter" },
    keys = {
      { "<A-;>", "<cmd>STSSelectChildNode<cr>", mode = { "v" }, desc = "Select child node" },
      { "<A-l>", "<cmd>STSSelectParentNode<cr>", mode = { "v" }, desc = "Select parent node" },
      { "<A-j>", "<cmd>STSSelectNextSiblingNode<cr>", mode = { "v" }, desc = "Select next node" },
      { "<A-k>", "<cmd>STSSelectPrevSiblingNode<cr>", mode = { "v" }, desc = "Select previous node" },
      {
        "<A-K>",
        function()
          vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
          return "g@l"
        end,
        mode = { "i", "n" },
        silent = true,
        expr = true,
        desc = "Swap with previous node",
      },
      {
        "<A-J>",
        function()
          vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
          return "g@l"
        end,
        mode = { "i", "n" },
        silent = true,
        expr = true,
        desc = "Swap with next node",
      },
      { "<A-J>", "<cmd>STSSwapNextVisual<cr>", mode = { "v" }, desc = "Swap with next node" },
      { "<A-K>", "<cmd>STSSwapPrevVisual<cr>", mode = { "v" }, desc = "Swap with previous node" },
    },
  },
  {
    -- TODO: better ftype local mapping with after/ftplugin
    "harrisoncramer/jump-tag",
    dependencies = { "nvim-treesitter" },
    ft = { "html", "javascriptreact", "typescriptreact", "vue" },
    -- config = function()
    --   vim.keymap.set(
    --     { "n", "i" },
    --     "<A-l>",
    --     "<cmd>lua require('jump-tag').jumpParent()<cr>",
    --     { buffer = true, desc = "Jump to parent node" }
    --   )
    -- end,
  },
  -- {
  --   -- TODO: don't need goto actions
  --   "drybalka/tree-climber.nvim",
  --   dependencies = { "nvim-treesitter" },
  --   keys = {
  --     {
  --       "<A-l>",
  --       "<cmd>lua require('tree-climber').goto_parent()<cr>",
  --       -- mode = { "i", "n" },
  --       desc = "Jump to parent node",
  --     },
  --     {
  --       "<A-;>",
  --       "<cmd>lua require('tree-climber').goto_child()<cr>",
  --       -- mode = { "n", "i" },
  --       desc = "Jump to child node",
  --     },
  --     {
  --       "<A-j>",
  --       "<cmd>lua require('tree-climber').goto_next()<cr>",
  --       -- mode = { "i", "n" },
  --       desc = "Jump to next node",
  --     },
  --     {
  --       "<A-k>",
  --       "<cmd>lua require('tree-climber').goto_prev()<cr>",
  --       -- mode = { "i", "n" },
  --       desc = "Jump to prev node",
  --     },
  --     {
  --       "<A-J>",
  --       "<cmd>lua require('tree-climber').swap_next()<cr>",
  --       -- mode = { "n", "i" },
  --       desc = "Swap with next node",
  --     },
  --     {
  --       "<A-K>",
  --       "<cmd>lua require('tree-climber').swap_prev()<cr>",
  --       -- mode = { "n", "i" },
  --       desc = "Swap with prev node",
  --     },
  --   },
  -- },
}
