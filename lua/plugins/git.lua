vim.keymap.set("n", "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Current line blame" })
vim.keymap.set("n", "<leader>gL", "<cmd>Gitsigns blame_line<cr>", { desc = "Blame line popup" })
vim.keymap.set({ "o", "x" }, "ih", ":<C-u>Gitsigns select_hunk<cr>", { desc = "Git hunk" })

local icons = require("shared").misc

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- { "davidsierradz/cmp-conventionalcommits", opts = {} },
      -- { "Cassin01/cmp-gitcommit", opts = {} },
      {
        "petertriho/cmp-git",
        dependencies = "nvim-lua/plenary.nvim",
        opts = { filetypes = { "gitcommit", "octo", "NeogitCommitMessage" }, github = { pull_requests = 10 } },
      },
    },
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.cmp_source_names["git"] = "(git)"
      -- opts.cmp_source_names["conventionalcommits"] = "(cc)"
      -- opts.cmp_source_names["gitcommit"] = "(cc)"

      -- cmp.setup.filetype({ "gitcommit", "NeogitCommitMessage" }, {
      --   sources = cmp.config.sources({ { name = "git" }, { name = "gitcommit" } }),
      -- })

      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        -- { name = "gitcommit" },
        -- { name = "conventionalcommits" },
        { name = "git", priority = 10 },
      }, 1, #opts.sources))
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = { defaults = { ["<leader>gs"] = { name = "+git search" }, ["<leader>gh"] = { name = "+git hunks" } } },
  },
  {
    "aaronhallaert/advanced-git-search.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "sindrets/diffview.nvim" },
    config = function()
      require("telescope").load_extension("advanced_git_search")
    end,
    keys = {
      { "<leader>gsc", "<cmd>AdvancedGitSearch search_log_content<cr>", desc = "Search repo log content" },
      { "<leader>gsC", "<cmd>AdvancedGitSearch search_log_content_file<cr>", desc = "Search file log content" },
      { "<leader>gsf", "<cmd>AdvancedGitSearch diff_commit_file<cr>", desc = "Diff current file with commit" },
      {
        "<leader>gsl",
        "<cmd>AdvancedGitSearch diff_commit_line<cr>",
        desc = "Diff current file with selected line history",
      },
      { "<leader>gsb", "<cmd>AdvancedGitSearch diff_branch_file<cr>", desc = "Diff file with branch" },
      { "<leader>gsB", "<cmd>AdvancedGitSearch changed_on_branch<cr>", desc = "Changed on current branch" },
      { "<leader>gsr", "<cmd>AdvancedGitSearch checkout_reflog<cr>", desc = "Checkout from reflog" },
    },
  },
  { "is0n/fm-nvim", keys = { { "<leader>gl", "<cmd>Lazygit<cr>", desc = "Git status (Lazygit)" } } },
  {
    "NeogitOrg/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = "Neogit",
    opts = {
      console_timeout = 10000,
      auto_show_console = true,
      disable_hint = true,
      disable_commit_confirmation = true,
      disable_insert_on_commit = true,
      kind = "tab",
      use_per_project_settings = true,
      remember_settings = true,
      ignored_settings = {
        "NeogitPushPopup--force-with-lease",
        "NeogitPushPopup--force",
        "NeogitCommitPopup--allow-empty",
      },
      integrations = {
        telescope = true,
        diffview = true,
      },
      signs = {
        section = { icons.collapsed, icons.expanded },
        item = { icons.collapsed, icons.expanded },
      },
      commit_popup = { kind = "auto" },
      mappings = { status = { ["l"] = "Toggle", ["h"] = "Toggle" } },
      -- use_telescope = true,
    },
    keys = { { "<leader>gg", "<cmd>Neogit<cr>", desc = "Git status (Neogit)" } },
  },
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
        file_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } } },
      },
    },
    keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview" } },
  },
  {
    "pwntester/octo.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "nvim-tree/nvim-web-devicons" },
    opts = function()
      vim.treesitter.language.register("markdown", "octo")
      return {}
    end,
    cmd = { "Octo" },
    keys = { { "<leader>go", "<cmd>Octo actions<cr>", desc = "Octo actions" } },
  },
  -- {
  --   "kdheepak/lazygit.nvim",
  --   init = function()
  --     vim.g.lazygit_floating_window_winblend = 5
  --   end,
  --   cmd = { "LazyGit", "LazyGitFilter", "LazyGitFilterCurrentFile" },
  --   keys = { { "<leader>gg", "<cmd>LazyGitCurrentFile<cr>", desc = "Lazygit" } },
  -- },
}
