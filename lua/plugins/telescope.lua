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
      "benfowler/telescope-luasnip.nvim",
      "nvim-telescope/telescope-bibtex.nvim",
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
      telescope.load_extension("luasnip")
      telescope.load_extension("bibtex")
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
      { "<leader>`", "", desc = "Switch other" },
      { "<leader><space>", lv_utils.telescope("files"), desc = "Find file (root)" },
      { "<leader>l", "<cmd>Lazy<cr>", desc = "Plugins" },

      { "<leader><tab><tab>", "<cmd>Telescope telescope-tabs list_tabs<cr>", desc = "Switch tab" },

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
      { "<leader>fT", false },

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

      -- { "<leader>nb", "<cmd>Telescope bibtex<cr>", desc = "Bibliography" },
      {
        "<leader>fb",
        function()
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")
          local Path = require("plenary.path")
          local Job = require("plenary.job")
          require("telescope._extensions.bibtex").exports.bibtex({
            attach_mappings = function(prompt_bufnr, map)
              require("telescope.actions").select_default:replace(function()
                local entry = action_state.get_selected_entry().id.content
                -- print(vim.inspect(action_state.get_selected_entry()))
                local cmd = vim.fn.has("win32") == 1 and "start" or vim.fn.has("mac") == 1 and "open" or "xdg-open"
                for _, line in pairs(entry) do
                  local match_base = "%f[%w]file"
                  local s = line:match(match_base .. "%s*=%s*%b{}")
                    or line:match(match_base .. '%s*=%s*%b""')
                    or line:match(match_base .. "%s*=%s*%d+")
                    or line:match("%s*books/[^\n]+")
                  if s ~= nil then
                    -- s = s:match("%b{}") or s:match('%b""') or s:match("%d+")
                    s = "/home/svitax/Desktop/docs/" .. (s:match("%{(.-)%}") or s:match("(books/[^\n]+)"))
                    -- print(s)
                    Job:new({
                      command = cmd,
                      args = { s },
                      detached = true,
                    }):start()
                    break
                  end
                end
                actions.close(prompt_bufnr)
              end)
              return true
            end,
          })
        end,
        desc = "Bibliography",
      },
      { "<leader>nB", "<cmd>e ~/Desktop/docs/lib.bib<cr>", desc = "Edit bib file" },

      { "<leader>sa", false },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search buffer" }, -- or grep current buffer
      -- TODO: search all open buffers
      { "<leader>sB", desc = "Search all open buffers" }, -- buffer (fuzzy) find / or grep only open buffers
      { "<leader>sc", false },
      { "<leader>sC", false },
      { "<leader>sd", lv_utils.telescope("live_grep"), desc = "Search current directory" }, -- grep project (default telescope grep)
      -- TODO: make dir-telescope not search .git folder
      { "<leader>sD", "<cmd>Telescope dir live_grep<cr>", desc = "Search other directory" }, -- choose a dir to grep in
      { "<leader>sf", false },
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
      {
        "<leader>ss",
        lv_utils.telescope(
          "grep_string",
          { path_display = { "smart" }, only_sort_text = true, word_math = "-w", search = "" }
        ),
        desc = "Fuzzy search project",
      },
      { "<leader>sS", "<cmd>Telescope luasnip<cr>", desc = "Search snippets" },
      -- TODO: dictionary
      { "<leader>st", desc = "Dictionary" },
      -- TODO: thesaurus
      { "<leader>sT", desc = "Thesaurus" },
      { "<leader>su", "<cmd>Telescope undo<cr>", desc = "Undo history" },
      { "<leader>sw", lv_utils.telescope("grep_string"), desc = "Search word (root)" },
      { "<leader>sW", lv_utils.telescope("grep_string", { cwd = false }), desc = "Search word (cwd)" },
    },
    opts = {
      extensions = {
        bibtex = {
          global_files = { "~/Desktop/docs/lib.bib" },
          search_keys = { "title", "author", "year" },
        },
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
            ["<c-f>"] = function(...)
              return require("telescope.actions").to_fuzzy_refine(...)
            end,
          },
        },
      }),
    },
  },
  { "prochri/telescope-all-recent.nvim", dependencies = { "kkharji/sqlite.lua" }, opts = {}, cmd = "Telescope" },
}
