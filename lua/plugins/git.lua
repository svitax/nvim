-- TODO: {"<leader>gL", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Current line blame"}
-- TODO: {"<leader>gl", "<cmd>Gitsigns blame_line<cr>", desc = "Blame line popup"}
return {
  -- { "idanarye/vim-merginal", dependencies = { "tpope/vim-fugitive" }, cmd = { "Merginal", "MerginalToggle" } },
  {
    "sodapopcan/vim-twiggy",
    dependencies = { "tpope/vim-fugitive" },
    cmd = "Twiggy",
    config = function()
      vim.cmd([[let g:twiggy_close_on_fugitive_command = 1]])
    end,
  },
  { "rbong/vim-flog", dependencies = { "tpope/vim-fugitive" }, cmd = "Flog" },
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git" },
    -- cc (create a commit)
    -- ca (amend last commit)
    -- cw (reword last commit)
    -- cf (create a fixup! commit for the commit under cursor)
    -- cF (create fixup! and immediately rebase it)
    -- cs (create a squash! commit for the commit under cursor)
    -- cS (create squash! and immediately rebase it)
    -- crc (revert commit under cursor)
    -- coo (checkout commit under cursor)
    -- czz (push stash)
    -- cza (apply topmost stash)
    -- czp (pop topmost stash)
    -- ri (interactive rebase)
    -- rf (autosquash rebase)
    -- ru (interactive rebase against upstream)
    -- rp (interactive rebase against push)
    -- rr (continue rebase)
    -- rs (skip current commit and continue rebase)
    -- re (edit current rebase todo list)
    -- rw (rebase commit under word set to reword)
    -- rm (rebase commit under word set to edit)
    -- rd (rebase commit under word set to drop)
    -- gq (close status buffer)
    keys = {
      {
        "<leader>gg",
        function()
          vim.cmd([[tab Git]])
          vim.cmd([[Twiggy]])
          local utils = require("utils")
          vim.api.nvim_feedkeys(utils.termcodes("<c-l>"), "i", true)
          -- "<cmd>Git<cr><cmd>Twiggy<cr><cmd>G<cr>"
        end,
        desc = "Fugitive",
      },
    },
  },
  -- {
  --   "TimUntersberger/neogit",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   cmd = "Neogit",
  --   -- opts = { kind = "replace" },
  --   keys = {
  --     {
  --       "<leader>gn",
  --       function()
  --         return require("neogit").open({ cwd = vim.fn.expand("%:p:h") })
  --       end,
  --       desc = "Neogit",
  --     },
  --   },
  -- },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewFileHistory", "DiffviewOpen" },
    opts = {
      keymaps = {
        view = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
          {
            "n",
            "co",
            function()
              require("diffview.actions").conflict_choose("ours")
            end,
            { desc = "Choose OURS version of a conflict" },
          },
          {
            "n",
            "ct",
            function()
              require("diffview.actions").conflict_choose("theirs")
            end,
            { desc = "Choose THEIRS version of a conflict" },
          },
          {
            "n",
            "cb",
            function()
              require("diffview.actions").conflict_choose("ours")
            end,
            { desc = "Choose BASE version of a conflict" },
          },
          {
            "n",
            "ca",
            function()
              require("diffview.actions").conflict_choose("ours")
            end,
            { desc = "Choose all versions of a conflict" },
          },
        },
        file_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
        },
      },
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview" },
    },
  },
}
