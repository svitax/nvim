-- TODO: replace syntax-tree-surfer and tree-climber.nvim with my fork of nvim-treeclimber
return {
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { "w", "<cmd>lua require('spider').motion('w')<cr>", mode = { "n", "o", "x" }, desc = "nvim-spider w" },
      { "e", "<cmd>lua require('spider').motion('e')<cr>", mode = { "n", "o", "x" }, desc = "nvim-spider e" },
      { "b", "<cmd>lua require('spider').motion('b')<cr>", mode = { "n", "o", "x" }, desc = "nvim-spider b" },
      { "ge", "<cmd>lua require('spider').motion('ge')<cr>", mode = { "n", "o", "x" }, desc = "nvim-spider ge" },
      -- <C-bs> maps to <C-h> in terminals, but I like to have <C-bs> delete the previous word.
      { "<C-bs>", "<space><cmd>normal db<cr>", mode = { "i", "c" }, desc = "nvim-spider db" },
      { "<C-h>", "<space><cmd>normal db<cr>", mode = { "i", "c" }, desc = "nvim-spider db" },
      -- <A-bs> is mapped to delete previous word on my keyboard (macos), make that consistent inside nvim
      { "<A-bs>", "<space><cmd>normal db<cr>", mode = { "i", "c" }, desc = "nvim-spider db" },
    },
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    opts = { useDefaultKeymaps = true },
    keys = {
      { "aw", "<cmd>lua require('various-textobjs').subword(false)<cr>", mode = { "o", "x" }, desc = "outer word" },
      { "iw", "<cmd>lua require('various-textobjs').subword(true)<cr>", mode = { "o", "x" }, desc = "inner word" },
    },
  },
  {
    "folke/flash.nvim",
    keys = { { "R", mode = { "o", "x" }, false }, { "S", mode = { "n", "o", "x" }, false } },
    opts = { modes = { search = { enabled = false } } },
  },
  { "folke/flash.nvim" },
  { "chrishrb/gx.nvim", event = { "BufEnter" }, dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
  {
    -- TODO: <A-j> and <A-n> in normal mode to move lines
    "ziontee113/syntax-tree-surfer",
    config = true,
    dependencies = { "nvim-treesitter" },
    keys = {
      { "<A-l>", "<cmd>STSSelectChildNode<cr>", mode = { "x" }, desc = "Select child node" },
      { "<A-h>", "<cmd>STSSelectParentNode<cr>", mode = { "x" }, desc = "Select parent node" },
      { "<A-j>", "<cmd>STSSelectNextSiblingNode<cr>", mode = { "x" }, desc = "Select next node" },
      { "<A-k>", "<cmd>STSSelectPrevSiblingNode<cr>", mode = { "x" }, desc = "Select previous node" },
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
      { "<A-J>", "<cmd>STSSwapNextVisual<cr>", mode = { "x" }, desc = "Swap with next node" },
      { "<A-K>", "<cmd>STSSwapPrevVisual<cr>", mode = { "x" }, desc = "Swap with previous node" },
    },
  },
  --   "ggandor/flit.nvim",
  --   commit = "5c9a78b97f7f4301473ea5e37501b5b1d4da167b", -- BUG: This fixes Too many arguments for function: strcharpart
  -- },
  -- {
  --   "ggandor/leap.nvim",
  --   commit = "8facf2eb6a378fd7691dce8c8a7b2726823e2408", -- BUG: This fixes Too many arguments for function: strcharpart
  --   config = function(_, opts)
  --     local leap = require("leap")
  --     for k, v in pairs(opts) do
  --       leap.opts[k] = v
  --     end
  --     leap.add_default_mappings(true)
  --     vim.keymap.del({ "x", "o" }, "x")
  --     vim.keymap.del({ "x", "o" }, "X")
  --     vim.keymap.del({ "n", "x", "o" }, "S")
  --     vim.keymap.set({ "n", "x", "o" }, "s", function()
  --       require("leap").leap({ target_windows = { vim.fn.win_getid() } })
  --     end, { desc = "Leap" })
  --     -- override any colorschemes highlights for leap (nightfox doesn't let me change it for some reason)
  --     leap.init_highlight(true)
  --   end,
  -- },
  -- {
  -- {
  --   -- TODO: better ftype local mapping with after/ftplugin
  --   "harrisoncramer/jump-tag",
  --   dependencies = { "nvim-treesitter" },
  --   ft = { "html", "javascriptreact", "typescriptreact", "vue" },
  --   -- config = function()
  --   --   vim.keymap.set(
  --   --     { "n", "i" },
  --   --     "<A-l>",
  --   --     "<cmd>lua require('jump-tag').jumpParent()<cr>",
  --   --     { buffer = true, desc = "Jump to parent node" }
  --   --   )
  --   -- end,
  -- },
  -- {
  --   -- TODO: Do i need urlview if I can get this functionality through tmux?
  --   -- do I have a plugin or autocmd that needs this?
  --   "axieax/urlview.nvim",
  --   opts = { jump = { prev = "[u", next = "]u" } },
  --   cmd = "UrlView",
  --   keys = { { "<leader>sU", "<cmd>UrlView<cr>", desc = "Search URLs" } },
  -- },
}
