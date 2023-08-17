local utils = require("utils")
local lv_utils = require("lazyvim.util")

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
    -- apply the config and additionally load fzf-native
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")

      -- Custom picker
      local custom = require("plugins.telescope.pickers")
      vim.keymap.set("n", "<leader>gb", custom.delta_branches_picker, { desc = "Checkout Git branches" })
      vim.keymap.set("n", "<leader>gc", custom.delta_commits_picker, { desc = "Checkout Git commits" })
      vim.keymap.set("n", "<leader>gC", custom.delta_bcommits_picker, { desc = "Checkout Git bcommits" })
      vim.keymap.set("n", "<leader>gt", custom.delta_status_picker, { desc = "Git status" })
      vim.keymap.set("n", "<leader>gT", custom.delta_stash_picker, { desc = "Git stash" })
    end,
    keys = {
      { "<leader>/", false },
      { "<leader>'", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
      {
        "<leader>*",
        lv_utils.telescope("lsp_document_symbols", {
          symbols = {
            "Class",
            "Function",
            "Method",
            "Constructor",
            "Interface",
            "Module",
            "Struct",
            "Trait",
            "Field",
            "Property",
          },
        }),
        desc = "Search symbols",
      },
      {
        "<leader>,",
        lv_utils.telescope("buffers", {
          -- NOTE: override default lv_utils.telescope cwd opt
          -- cwd = "",
          initial_mode = "normal",
          -- sort_lastused = false,
          -- sort_mru = true,
          attach_mappings = function(_, map)
            map("i", "<c-x>", require("telescope.actions").delete_buffer)
            map("n", "d", require("telescope.actions").delete_buffer)
            map("n", "q", require("telescope.actions").close)
            map("n", ";", require("telescope.actions").select_default)
            return true
          end,
        }),
        desc = "Switch buffers",
      },
      -- { "<leader>/", lv_utils.telescope("live_grep"), desc = "Search project" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command history" },
      -- { "<leader>`", "", desc = "Switch other" },
      {
        "<leader><space>",
        lv_utils.telescope("files", { prompt_title = "Find files (git)" }),
        desc = "Find file (cwd)",
      },
      { "<leader>P", "<cmd>Lazy<cr>", desc = "Plugins" },

      {
        "<leader>bb",
        lv_utils.telescope("buffers", {
          -- NOTE: override default lv_utils.telescope cwd opt
          -- cwd = "",
          initial_mode = "normal",
          -- sort_lastused = false,
          -- sort_mru = true,
          attach_mappings = function(_, map)
            map("i", "<c-x>", require("telescope.actions").delete_buffer)
            map("n", "d", require("telescope.actions").delete_buffer)
            map("n", "q", require("telescope.actions").close)
            map("n", ";", require("telescope.actions").select_default)
            return true
          end,
        }),
        desc = "Switch buffers",
      },

      {
        "<leader>cj",
        lv_utils.telescope("lsp_document_symbols", {
          symbols = {
            "Class",
            "Function",
            "Method",
            "Constructor",
            "Interface",
            "Module",
            "Struct",
            "Trait",
            "Field",
            "Property",
          },
        }),
        desc = "Jump to symbol in file",
      },
      {
        "<leader>cJ",
        lv_utils.telescope("lsp_workspace_symbols", {
          symbols = {
            "Class",
            "Function",
            "Method",
            "Constructor",
            "Interface",
            "Module",
            "Struct",
            "Trait",
            "Field",
            "Property",
          },
        }),
        desc = "Jump to symbol in workspace",
      },

      {
        "<leader>f.",
        lv_utils.telescope(
          "git_files",
          { cwd = "~/.dotfiles/", prompt_title = "Find in dotfiles (git)", show_untracked = true }
        ),
        -- { cwd = "~/", find_command = { "rg", "--hidden", "--files", "--follow", "--glob=!.git" } }
        desc = "Find file in dotfiles",
      },
      { "<leader>fb", false },
      -- TODO: open project editorconfig
      -- { "<leader>fc", desc = "Open project editorconfig" },
      {
        "<leader>fe",
        lv_utils.telescope("git_files", { cwd = "~/.config/nvim/", show_untracked = true }),
        desc = "Find file in .config/nvim",
      },
      { "<leader>ff", lv_utils.telescope("files"), desc = "Find file (cwd)" },
      { "<leader>fF", false },
      -- { "<leader>fn", lv_utils.telescope("git_files", { cwd = "~/Desktop/notes" }), desc = "Find notes" },
      -- { "<leader>fp", "<cmd>Telescope projections<cr>", desc = "Find project" },
      { "<leader>fT", false },

      -- { "<leader>g" },
      { "<leader>gb" },
      { "<leader>gc" },
      { "<leader>gC" },
      { "<leader>gs" },
      -- { "<leader>gS" },

      { "<leader>hA", "<cmd>Telescope autocommands<cr>", desc = "Autocommands" },
      { "<leader>hc", "<cmd>Telescope command_history<cr>", desc = "Command history" },
      { "<leader>hC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>hH", "<cmd>Telescope help_tags<cr>", desc = "Help pages" },
      { "<leader>hg", "<cmd>Telescope highlights<cr>", desc = "Highlight groups" },
      { "<leader>hk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>hM", "<cmd>Telescope man_pages<cr>", desc = "Man pages" },
      { "<leader>ho", "<cmd>Telescope vim_options<cr>", desc = "Options" },

      { "<leader>sa", false },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy search buffer" }, -- or grep current buffer
      -- TODO: search all open buffers
      -- { "<leader>sB", desc = "Search all open buffers" }, -- buffer (fuzzy) find / or grep only open buffers
      { "<leader>sc", false },
      { "<leader>sC", false },
      { "<leader>sf", false },
      { "<leader>sg", false },
      { "<leader>sG", false },
      { "<leader>sh", false },
      { "<leader>sH", false },
      { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jump list" },
      { "<leader>sk", false },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to mark" },
      { "<leader>sM", false },
      -- { "<leader>sp", lv_utils.telescope("live_grep"), desc = "Search project" }, -- grep project (default telescope grep)
      -- TODO: search other project
      -- { "<leader>sP", desc = "Search other project" }, -- prompt a project to search in
      -- { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
      { "<leader>sR", false },
      {
        "<leader>ss",
        lv_utils.telescope("grep_string", {
          prompt_title = "Fuzzy grep project",
          path_display = { "smart" },
          only_sort_text = true,
          word_math = "-w",
          search = "",
        }),
        desc = "Fuzzy search project",
      },
      { "<leader>sS", false },
      -- TODO: dictionary and thesaurus
      -- { "<leader>st", desc = "Dictionary" },
      -- { "<leader>sT", desc = "Thesaurus" },
      { "<leader>sT", false },
      -- TODO: search word
      -- { "<leader>sw", lv_utils.telescope("grep_string"), desc = "Search word (root)" },
      -- { "<leader>sW", lv_utils.telescope("grep_string", { cwd = false }), desc = "Search word (cwd)" },
      { "<leader>sw", false },
      { "<leader>sW", false },
    },
    opts = {
      extensions = {
        -- howdoi = { pager_command = "bat --color=always --theme=gruvbox-dark" },
        -- bibtex = { global_files = { "~/Dropbox/docs/lib.bib" }, search_keys = { "title", "author", "year" } },
        bibtex = { global_files = { "~/OneDrive/docs/lib.bib" }, search_keys = { "title", "author", "year" } },
        repo = { list = { search_dirs = { "~/projects", "~/.config/nvim" } } },
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
        },
        smart_open = { match_algorithm = "fzf" },
        advanced_git_search = {
          diff_plugin = "diffview",
          telescope_theme = { search_log_content = { layout_config = { height = 0.80, preview_width = 0.75 } } },
        },
        -- bookmarks = { selected_browser = "edge", buku_include_tags = true },
      },
      defaults = require("telescope.themes").get_ivy({
        -- wrap_results = true,
        mappings = {
          i = {
            ["<c-h>"] = function()
              vim.api.nvim_feedkeys(utils.termcodes("<c-s-w>"), "i", true)
            end,
            ["<c-j>"] = function(...)
              return require("telescope.actions").move_selection_next(...)
            end,
            ["<c-k>"] = function(...)
              return require("telescope.actions").move_selection_previous(...)
            end,
            ["<c-f>"] = function(...)
              return require("telescope.actions").to_fuzzy_refine(...)
            end,
            ["<C-s>"] = function(...)
              return require("telescope.actions").cycle_previewers_next(...)
            end,
            ["<C-a>"] = function(...)
              return require("telescope.actions").cycle_previewers_prev(...)
            end,
          },
        },
      }),
    },
  },
  -- {
  --   -- NOTE: oldfiles are only saved when the program is closed. so if you open a file you haven't
  --   -- worked on before, the builtin telescope oldfiles picker will not show it.
  --   "smartpde/telescope-recent-files",
  --   dependencies = { "nvim-telescope/telescope.nvim" },
  --   config = function()
  --     require("telescope").load_extension("recent_files")
  --   end,
  --   keys = {
  --     { "<leader>fr", "<cmd>Telescope recent_files pick<cr>", desc = "Recent files" },
  --     { "<leader>fR", "<cmd>Telescope recent_files pick only_cwd=true<cr>", desc = "Recent files (cwd)" },
  --   },
  -- },
  {
    "tsakirist/telescope-lazy.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("lazy")
    end,
    keys = { { "<leader>sl", "<cmd>Telescope lazy<cr>", desc = "Search plugins" } },
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("undo")
    end,
    keys = { { "<leader>su", "<cmd>Telescope undo<cr>", desc = "Undo history" } },
  },
  {
    "cljoly/telescope-repo.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("repo")
    end,
    -- TODO: wait until author provides custom actions for the repo list picker
    keys = { { "<leader>fp", "<cmd>Telescope repo list show_untracked=true<cr>", desc = "Find project" } },
  },
  {
    "benfowler/telescope-luasnip.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("luasnip")
    end,
    keys = { { "<leader>sS", "<cmd>Telescope luasnip<cr>", desc = "Search snippets" } },
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("live_grep_args")
    end,
    keys = {
      {
        "<leader>/",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args({
            prompt_title = "Search project (args)",
            attach_mappings = function(_, map)
              map("i", "<c-l>", require("telescope-live-grep-args.actions").quote_prompt())
              map("i", "<c-;>", require("telescope-live-grep-args.actions").quote_prompt({ postfix = " -t " }))
              map("i", "<c-o>", require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " }))
              return true
            end,
          })
        end,
        desc = "Search project",
      },
      -- grep dotfiles directory
      {
        "<leader>s.",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args({
            cwd = "~/.dotfiles",
            prompt_title = "Search dotfiles (args)",
            attach_mappings = function(_, map)
              map("i", "<c-l>", require("telescope-live-grep-args.actions").quote_prompt())
              map("i", "<c-;>", require("telescope-live-grep-args.actions").quote_prompt({ postfix = " -t" }))
              map("i", "<c-o>", require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " }))
              return true
            end,
          })
        end,
        desc = "Search .dotfiles",
      },
      -- grep cwd (of current file)
      {
        "<leader>sd",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args({
            cwd = utils.get_head_dir(),
            prompt_title = "Search cwd (args)",
            attach_mappings = function(_, map)
              map("i", "<c-l>", require("telescope-live-grep-args.actions").quote_prompt())
              map("i", "<c-;>", require("telescope-live-grep-args.actions").quote_prompt({ postfix = " -t" }))
              map("i", "<c-o>", require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " }))
              return true
            end,
          })
        end,
        desc = "Search cwd",
      },
      -- grep nvim config
      {
        "<leader>se",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args({
            cwd = "~/.config/nvim",
            prompt_title = "Search Neovim config (args)",
            attach_mappings = function(_, map)
              map("i", "<c-l>", require("telescope-live-grep-args.actions").quote_prompt())
              map("i", "<c-;>", require("telescope-live-grep-args.actions").quote_prompt({ postfix = " -t" }))
              map("i", "<c-o>", require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " }))
              return true
            end,
          })
        end,
        desc = "Search .config/nvim",
      },
      -- grep notes
      {
        "<leader>sn",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args({
            -- cwd = "~/Dropbox/notes",
            cwd = "~/Drive/notes",
            prompt_title = "Search notes (args)",
            attach_mappings = function(_, map)
              map("i", "<c-l>", require("telescope-live-grep-args.actions").quote_prompt())
              map("i", "<c-;>", require("telescope-live-grep-args.actions").quote_prompt({ postfix = " -t" }))
              map("i", "<c-o>", require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " }))
              return true
            end,
          })
        end,
        desc = "Search notes",
      },
      -- grep project (default telescope grep)
      {
        "<leader>sp",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args({
            prompt_title = "Search project (args)",
            attach_mappings = function(_, map)
              map("i", "<c-l>", require("telescope-live-grep-args.actions").quote_prompt())
              map("i", "<c-;>", require("telescope-live-grep-args.actions").quote_prompt({ postfix = " -t" }))
              map("i", "<c-o>", require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " }))
              return true
            end,
          })
        end,
        desc = "Search project",
      },
    },
  },
  {
    -- NOTE: need "cargo install ast-grep"
    "Marskey/telescope-sg",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("ast_grep")
    end,
    keys = { { "<leader>sa", "<cmd>Telescope ast_grep<cr>", desc = "Search AST nodes" } },
  },
  {
    "luckasRanarison/nvim-devdocs",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = {
      "DevdocsFetch",
      "DevdocsInstall",
      "DevdocsUninstall",
      "DevdocsOpen",
      "DevdocsOpenFloat",
      "DevdocsUpdate",
      "DevdocsUpdateAll",
    },
    opts = { previewer_cmd = "glow", cmd_args = { "-s", "dark", "-w", "80" } },
    keys = {
      { "<leader>hd" },
      { "<leader>hdi", "<cmd>DevdocsInstall<cr>", desc = "Install Devdocs" },
      { "<leader>hdm", "<cmd>DevdocsOpenFloat scikit_learn<cr>", desc = "scikit-learn" },
      { "<leader>hdp", "<cmd>DevdocsOpenFloat python<cr>", desc = "Python" },
      { "<leader>hdj", "<cmd>DevdocsOpenFloat javascript<cr>", desc = "JavaScript" },
      { "<leader>hdn", "<cmd>DevdocsOpenFloat node<cr>", desc = "Node" },
    },
  },
  {
    "danielfalk/smart-open.nvim",
    dependencies = {
      "kkharji/sqlite.lua", -- need export DYLD_LIBRARY_PATH=/usr/local/opt/sqlite/lib:/usr/lib to work on macos
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension("smart_open")
    end,
    keys = {
      { "<leader>fr", "<cmd>Telescope smart_open<cr>", desc = "Find recent files" },
      { "<leader>fR", "<cmd>Telescope smart_open cwd_only=true<cr>", desc = "Find recent files (cwd)" },
    },
  },
  -- {
  --   "dhruvmanila/browser-bookmarks.nvim",
  --   version = "*",
  --   -- Only required to override the default options
  --   -- opts = { selected_browser = "edge" },
  --   dependencies = {
  --     "nvim-telescope/telescope.nvim",
  --     "kkharji/sqlite.lua", -- Only if your selected browser is Firefox, Waterfox or buku
  --   },
  --   config = function(_, opts)
  --     require("telescope").load_extension("bookmarks")
  --   end,
  --   keys = {
  --     { "<leader>fk", "<cmd>Telescope bookmarks<cr>", desc = "Find bookmarks" },
  --   },
  -- },
}
