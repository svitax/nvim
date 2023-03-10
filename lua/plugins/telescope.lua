local utils = require("utils")
local lv_utils = require("lazyvim.util")

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
    -- apply the config and additionally load fzf-native
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")

      local previewers = require("telescope.previewers")
      local delta = previewers.new_termopen_previewer({
        get_command = function(entry)
          if (entry.status == "M ") or (entry.status == "A ") then
            return { "git", "-c", "core.pager=delta", "-c", "delta.side-by-side=false", "diff", "--staged", entry.value }
          end
          if entry.status == "??" then
            return { "bat", entry.value }
          end
          return { "git", "-c", "core.pager=delta", "-c", "delta.side-by-side=false", "diff", entry.value }
        end,
      })
      local delta_bcommits = require("telescope.previewers").new_termopen_previewer({
        get_command = function(entry)
          return {
            "git",
            "-c",
            "core.pager=delta",
            "-c",
            "delta.side-by-side=false",
            "diff",
            entry.value .. "^!",
            "--",
            entry.current_file,
          }
        end,
      })

      vim.keymap.set(
        "n",
        "<leader>gb",
        lv_utils.telescope("git_branches", {
          attach_mappings = function(_, map)
            -- map("i", "<c-f>", require("telescope.extensions").changed_files.actions.find_changed_files)
            map("i", "<CR>", function(prompt_bufnr)
              local entry = require("telescope.actions.state").get_selected_entry()
              require("telescope.actions").close(prompt_bufnr)
              vim.cmd("DiffviewOpen " .. entry.name)
            end)
            return true
          end,
          previewer = delta,
          layout_config = { height = 0.8, preview_width = 0.8 },
        })
      )
      vim.keymap.set(
        "n",
        "<leader>gc",
        lv_utils.telescope("git_commits", {
          attach_mappings = function(_, map)
            -- map("i", "<c-f>", require("telescope.extensions").changed_files.actions.find_changed_files)
            map("i", "<CR>", function(prompt_bufnr)
              local entry = require("telescope.actions.state").get_selected_entry()
              require("telescope.actions").close(prompt_bufnr)
              vim.cmd("DiffviewOpen " .. entry.value)
            end)
            return true
          end,
          previewer = { delta, previewers.git_commit_message.new({}), previewers.git_commit_diff_as_was.new({}) },
          layout_config = { height = 0.8, preview_width = 0.8 },
        })
      )
      vim.keymap.set(
        "n",
        "<leader>gC",
        lv_utils.telescope("git_bcommits", {
          previewer = {
            delta_bcommits,
            previewers.git_commit_message.new({}),
            previewers.git_commit_diff_as_was.new({}),
          },
          layout_config = { height = 0.8, preview_width = 0.8 },
        })
      )
      vim.keymap.set(
        "n",
        "<leader>gs",
        lv_utils.telescope("git_status", { previewer = delta, layout_config = { height = 0.8, preview_width = 0.8 } })
      )
    end,

    keys = {
      { "<leader>'", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
      {
        "<leader>*",
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
        desc = "Search symbols",
      },
      {
        "<leader>,",
        lv_utils.telescope("buffers", {
          initial_mode = "normal",
          sort_lastused = false,
          sort_mru = true,
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
      { "<leader>/", lv_utils.telescope("live_grep"), desc = "Search project" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command history" },
      -- { "<leader>`", "", desc = "Switch other" },
      { "<leader><space>", lv_utils.telescope("files"), desc = "Find file (root)" },
      { "<leader>l", "<cmd>Lazy<cr>", desc = "Plugins" },

      {
        "<leader>bb",
        lv_utils.telescope("buffers", {
          initial_mode = "normal",
          sort_lastused = false,
          sort_mru = true,
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
        lv_utils.telescope("git_files", { cwd = "~/.dotfiles/", show_untracked = true }),
        -- { cwd = "~/", find_command = { "rg", "--hidden", "--files", "--follow", "--glob=!.git" } }
        desc = "Find file in dotfiles",
      },
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

      { "<leader>gb", desc = "Git branches" },
      { "<leader>gc", desc = "Git commits" },
      { "<leader>gC", desc = "Git bcommits" },
      { "<leader>gs", desc = "Git status" },

      { "<leader>ha", "<cmd>Telescope autocommands<cr>", desc = "Autocommands" },
      { "<leader>hc", "<cmd>Telescope command_history<cr>", desc = "Command history" },
      { "<leader>hC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>hh", "<cmd>Telescope help_tags<cr>", desc = "Help pages" },
      { "<leader>hH", "<cmd>Telescope highlights<cr>", desc = "Highlight groups" },
      { "<leader>hk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>hm", "<cmd>Noice telescope<cr>", desc = "Messages" }, -- noice
      { "<leader>hM", "<cmd>Telescope man_pages<cr>", desc = "Man pages" },
      { "<leader>he", "<cmd>Noice errors<cr>", desc = "Errors" }, -- noice
      { "<leader>ho", "<cmd>Telescope vim_options<cr>", desc = "Options" },

      { "<leader>sa", false },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search buffer" }, -- or grep current buffer
      -- TODO: search all open buffers
      -- { "<leader>sB", desc = "Search all open buffers" }, -- buffer (fuzzy) find / or grep only open buffers
      { "<leader>sc", false },
      { "<leader>sC", false },
      -- TODO: search only current dir
      { "<leader>sd", lv_utils.telescope("live_grep"), desc = "Search current directory" }, -- grep project (default telescope grep)
      { "<leader>sf", false },
      { "<leader>sg", false },
      { "<leader>sG", false },
      { "<leader>sh", false },
      { "<leader>sH", false },
      { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jump list" },
      { "<leader>sk", false },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to mark" },
      { "<leader>sM", false },
      { "<leader>sn", lv_utils.telescope("live_grep", { cwd = "~/.config/nvim" }), desc = "Search .config/nvim" }, -- grep nvim config
      { "<leader>sp", lv_utils.telescope("live_grep"), desc = "Search project" }, -- grep project (default telescope grep)
      -- TODO: search other project
      -- { "<leader>sP", desc = "Search other project" }, -- prompt a project to search in
      {
        "<leader>ss",
        lv_utils.telescope(
          "grep_string",
          { path_display = { "smart" }, only_sort_text = true, word_math = "-w", search = "" }
        ),
        desc = "Fuzzy search project",
      },
      -- TODO: dictionary and thesaurus
      -- { "<leader>st", desc = "Dictionary" },
      -- { "<leader>sT", desc = "Thesaurus" },
      { "<leader>sw", lv_utils.telescope("grep_string"), desc = "Search word (root)" },
      { "<leader>sW", lv_utils.telescope("grep_string", { cwd = false }), desc = "Search word (cwd)" },
    },
    opts = {
      extensions = {
        howdoi = { pager_command = "bat" },
        bibtex = { global_files = { "~/Desktop/docs/lib.bib" }, search_keys = { "title", "author", "year" } },
        repo = { list = { search_dirs = { "~/projects", "~/.config/nvim" } } },
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
          },
        },
      }),
    },
  },
  { "prochri/telescope-all-recent.nvim", dependencies = { "kkharji/sqlite.lua" }, opts = {}, cmd = "Telescope" },

  -- {
  --   "nvim-telescope/telescope-file-browser.nvim",
  --   dependencies = { "nvim-telescope/telescope.nvim" },
  --   config = function()
  --     require("telescope").load_extension("file_browser")
  --   end,
  --   keys = {
  --     -- TODO: find directory
  --     { "<leader>fd", "<cmd>Telescope file_browser<cr>", desc = "Find directory" }, -- Search for directories, on <cr> open dirvish/dired
  --     {
  --       "<leader>fE",
  --       function()
  --         require("telescope").extensions.file_browser.file_browser({
  --           cwd = "~/.config/nvim",
  --           cwd_to_path = true,
  --         })
  --       end,
  --       desc = "Browse .config/nvim",
  --     },
  --   },
  -- },
  -- {
  --   "princejoogie/dir-telescope.nvim",
  --   dependencies = { "nvim-telescope/telescope.nvim" },
  --   config = function()
  --     require("telescope").load_extension("dir")
  --   end,
  --   -- TODO: make dir-telescope not search .git and node_modules folders
  --   -- choose a dir to grep in
  --   keys = { { "<leader>sD", "<cmd>Telescope dir live_grep<cr>", desc = "Search other directory" } },
  -- },
  {
    "smartpde/telescope-recent-files",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("recent_files")
    end,
    keys = { { "<leader>fr", "<cmd>Telescope recent_files pick<cr>", desc = "Recent files" } },
  },
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
    "zane-/howdoi.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("howdoi")
    end,
    keys = {
      -- NOTE: telescope-howdoi previewer shows no colors
      { "<leader>hd", "<cmd>Telescope howdoi<cr>", desc = "Howdoi" },
    },
  },
  {
    "lalitmee/browse.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    -- cmd = {
    --   "Browse",
    --   "BrowseBookmarks",
    --   "BrowseInputSearch",
    --   "BrowseDevdocsSearch",
    --   "BrowseDevdocsFiletypeSearch",
    --   "BrowseMdnSearch",
    -- },
    opts = {
      bookmarks = {
        ["npm-search"] = "https://npmjs.com/search?q=%s",
        ["github-code-search"] = "https://github.com/search?q=%s&type=code",
        ["github-repo-search"] = "https://github.com/search?q=%s&type=repositories",
        ["github-issues-search"] = "https://github.com/search?q=%s&type=issues",
        ["github-pulls-search"] = "https://github.com/search?q=%s&type=pullrequests",
      },
    },
    keys = {
      { "<leader>soo", "<cmd>lua require('browse').input_search()<cr>", desc = "Look up online" },
      { "<leader>sob", "<cmd>lua require('browse').open_bookmarks()<cr>", desc = "Bookmarks" },
      { "<leader>sos", "<cmd>lua require('browse').browse()<cr>", desc = "Browse" },
      { "<leader>sod", "<cmd>lua require('browse.devdocs').search()<cr>", desc = "Devdocs" },
      {
        "<leader>sof",
        "<cmd>lua require('browse.devdocs').search_with_filetype()<cr>",
        desc = "Devdocs with filetype",
      },
    },
  },
}
