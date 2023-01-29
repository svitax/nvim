local utils = require("utils")
local lv_utils = require("lazyvim.util")

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-file-browser.nvim",
      "LukasPietzschmann/telescope-tabs",
      "princejoogie/dir-telescope.nvim",
      "smartpde/telescope-recent-files",
      "tsakirist/telescope-lazy.nvim",
      "debugloop/telescope-undo.nvim",
      "cljoly/telescope-repo.nvim",
      -- {
      --   "GnikDroy/projections.nvim",
      --   opts = { workspaces = { "~/projects", "~/.dotfiles/nvim/.config" } },
      --   config = function(_, opts)
      --     require("projections").setup(opts)
      --
      --     local Session = require("projections.session")
      --     local Workspace = require("projections.workspace")
      --
      --     -- Autostore session on VimExit
      --     vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
      --       callback = function()
      --         Session.store(vim.loop.cwd())
      --       end,
      --     })
      --
      --     -- Manual session commands
      --     vim.api.nvim_create_user_command("StoreProjectSession", function()
      --       Session.store(vim.loop.cwd())
      --     end, {})
      --     vim.api.nvim_create_user_command("RestoreProjectSession", function()
      --       Session.restore(vim.loop.cwd())
      --     end, {})
      --
      --     -- Workspace command
      --     vim.api.nvim_create_user_command("AddWorkspace", function()
      --       Workspace.add(vim.loop.cwd())
      --     end, {})
      --   end,
      -- },
    },
    -- apply the config and additionally load fzf-native
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.load_extension("dir")
      telescope.load_extension("recent_files")
      telescope.load_extension("lazy")
      telescope.load_extension("undo")
      telescope.load_extension("repo")
      -- telescope.load_extension("projections")
    end,

    keys = {
      { "<leader>sa", false },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search buffer" }, -- or grep current buffer
      -- TODO: search all open buffers
      { "<leader>sB", desc = "Search all open buffers" }, -- buffer (fuzzy) find / or grep only open buffers
      { "<leader>sc", false },
      { "<leader>sC", false },
      { "<leader>sd", lv_utils.telescope("live_grep"), desc = "Search current directory" }, -- grep project (default telescope grep)
      -- TODO: make dir-telescope not search .git folder
      { "<leader>sD", "<cmd>Telescope dir live_grep<cr>", desc = "Search other directory" }, -- choose a dir to grep in
      { "<leader>sg", false },
      { "<leader>sG", false },
      { "<leader>sh", false },
      { "<leader>sH", false },
      { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jump list" },
      { "<leader>sk", false },
      { "<leader>sl", "<cmd>Telescope lazy<cr>", desc = "Search plugins" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to mark" },
      { "<leader>sM", false },
      { "<leader>sn", lv_utils.telescope("live_grep", { cwd = "~/.config/nvim" }), desc = "Search .config/nvim" }, -- grep nvim config
      -- TODO: look up online
      { "<leader>so", desc = "Look up online" },
      -- TODO: search project
      { "<leader>sp", lv_utils.telescope("live_grep"), desc = "Search project" }, -- grep project (default telescope grep)
      -- TODO: search other project
      { "<leader>sP", desc = "Search other project" }, -- prompt a project to search in
      { "<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search buffer" }, -- or grep current buffer
      -- TODO: dictionary
      { "<leader>st", desc = "Dictionary" },
      -- TODO: thesaurus
      { "<leader>sT", desc = "Thesaurus" },
      { "<leader>su", "<cmd>Telescope undo<cr>", desc = "Undo history" },
      { "<leader>sw", lv_utils.telescope("grep_string"), desc = "Search word (root dir)" },
      { "<leader>sW", lv_utils.telescope("grep_string", { cwd = false }), desc = "Search word (cwd)" },

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
      -- { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "Switch buffers" },
      { "<leader>'", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
      {
        "<leader>f.",
        lv_utils.telescope(
          "git_files",
          -- { cwd = "~/", find_command = { "rg", "--hidden", "--files", "--follow", "--glob=!.git" } }
          { cwd = "~/.dotfiles/", show_untracked = true }
        ),
        desc = "Find file in dotfiles",
      },
      -- TODO: open project editorconfig
      { "<leader>fc", desc = "Open project editorconfig" },
      -- TODO: find directory
      { "<leader>fd", "<cmd>Telescope file_browser<cr>", desc = "Find directory" }, -- Search for directories, on <cr> open dirvish/dired
      {
        "<leader>fe",
        lv_utils.telescope("git_files", { cwd = "~/.config/nvim/", show_untracked = true }),
        desc = "Find file in .config/nvim",
      },
      {
        "<leader>fE",
        function()
          require("telescope").extensions.file_browser.file_browser({
            cwd = "~/.config/nvim",
            cwd_to_path = true,
          })
        end,
        desc = "Browse .config/nvim",
      },
      { "<leader>ff", lv_utils.telescope("files"), desc = "Find file (cwd)" },
      { "<leader>fF", false },
      -- { "<leader>fn", lv_utils.telescope("git_files", { cwd = "~/Desktop/notes" }), desc = "Find notes" },
      -- { "<leader>fp", "<cmd>Telescope projections<cr>", desc = "Find project" },
      -- TODO: wait until author provides custom actions for the repo list picker
      { "<leader>fp", "<cmd>Telescope repo list show_untracked=true<cr>", desc = "Find project" },
      { "<leader>fr", "<cmd>Telescope recent_files pick<cr>", desc = "Recent files" },
      { "<leader>ss", false },
      { "<leader><tab><tab>", "<cmd>Telescope telescope-tabs list_tabs<cr>", desc = "Switch tab" },
      { "<leader>fT", false },
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
    },
    opts = {
      extensions = {
        repo = {
          list = {
            search_dirs = {
              "~/projects",
              "~/.config/nvim",
            },
          },
        },
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
          },
        },
      }),
    },
  },
  { "prochri/telescope-all-recent.nvim", dependencies = { "kkharji/sqlite.lua" }, opts = {}, cmd = "Telescope" },
}
