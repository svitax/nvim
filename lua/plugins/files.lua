local shared = require("shared")
local modeline_icons = shared.modeline_icons

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- dependencies = { { "prncss-xyz/neo-tree-zk.nvim" }, { "mickael-menu/zk-nvim" } },
    keys = {
      { "<leader>fe", false },
      { "<leader>fE", false },
      { "<leader>e", false },
      { "<leader>E", false },
      { "<leader>l", "<cmd>Neotree toggle reveal=true position=float dir=./<cr>", desc = "File tree (cwd)" },
      { "<leader>L", "<cmd>Neotree toggle reveal=true position=float dir=~/<cr>", desc = "File tree (home)" },
      -- { "<leader>ne", "<cmd>Neotree toggle source=zk position=float<cr>", desc = "Explore notes" },
    },
    opts = {
      close_if_last_window = true,
      enable_normal_mode_for_inputs = true,
      sources = {
        "filesystem",
        "buffers",
        "git_status",
      },
      window = {
        mappings = {
          ["e"] = "switch_to_filesystem",
          ["b"] = "switch_to_buffers",
          ["i"] = "switch_to_git_status",
          ["l"] = "nav_to_parent",
          [";"] = "nav_to_child",
          ["s"] = "open_split",
          ["v"] = "open_vsplit",
          ["."] = "toggle_hidden",
          ["<c-c>"] = "clear_filter",
          ["/"] = "filter_on_submit",
          ["f"] = "fuzzy_finder",
          -- ["dd"] = "delete_node_without_confirm",
          -- ["d"] = "none",
          -- ["yy"] = "copy_to_clipboard",
          -- ["y"] = "none",
          -- ["Y"] = "copy_relative_path",
        },
        fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
          ["<down>"] = "move_cursor_down",
          ["<C-n>"] = "move_cursor_down",
          ["<C-j>"] = "move_cursor_down",
          ["<up>"] = "move_cursor_up",
          ["<C-p>"] = "move_cursor_up",
          ["<C-k>"] = "move_cursor_up",
        },
      },

      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,

        hijack_netrw_behavior = "open_current",
        window = { mappings = { ["o"] = "system_open" } },
        components = {
          grapple_index = function(config, node, state)
            local grapple = require("grapple")
            local path = node.path
            -- print(grapple.find({ file_path = path }))
            local tag = grapple.find({ file_path = path })
            local success, key = pcall(grapple.key, tag)
            if success and key then
              return {
                text = modeline_icons.tag .. " [" .. key .. "]", -- <-- Add your favorite harpoon like arrow here
                highlight = config.highlight or "NeoTreeDirectoryIcon",
              }
            else
              return {}
            end
          end,
          icon_padding = function()
            return { text = " " }
          end,
          commands = {
            delete_node_without_confirm = function(state, callback)
              require("neo-tree.sources.filesystem.lib.fs_actions").delete_node(
                state.tree:get_node().path,
                callback,
                true
              )
            end,
            copy_relative_path = function(state)
              local path, _ = string.gsub(state.tree:get_node():get_id(), vim.fn.getcwd() .. "/", "")
              path, _ = string.gsub(path, "[\n\r]", "")

              vim.notify("Copied: '" .. path .. "'")
              vim.api.nvim_command("silent !echo '" .. path .. "' | pbcopy")
            end,
          },
        },
        renderers = {
          directory = {
            { "icon_padding" },
            { "icon" },
            { "icon_padding" },
            { "current_filter" },
            {
              "container",
              content = {
                { "name", use_git_status_colors = false, zindex = 10 },
                {
                  "symlink_target",
                  zindex = 10,
                  highlight = "NeoTreeSymbolicLinkTarget",
                },
                { "clipboard", zindex = 10 },
                -- { "diagnostics", errors_only = true, zindex = 20, align = "right", hide_when_expanded = true },
                -- { "git_status", zindex = 20, align = "right", hide_when_expanded = true },
              },
            },
          },
          file = {
            { "icon_padding" },
            { "icon" },
            { "icon_padding" },
            {
              "container",
              content = {
                -- { "name", zindex = 10 },
                { "name", use_git_status_colors = false, zindex = 10 },
                {
                  "symlink_target",
                  zindex = 10,
                  highlight = "NeoTreeSymbolicLinkTarget",
                },
                { "clipboard", zindex = 10 },
                { "bufnr", zindex = 10 },
                { "modified", zindex = 20, align = "right" },
                -- { "diagnostics", zindex = 20, align = "right" },
                -- { "git_status", zindex = 20, align = "right", highlight = "NeoTreeDimText" },
              },
            },
            { "grapple_index" },
          },
        },
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = { ".DS_Store" },
          never_show = { ".DS_Store", "node_modules" },
        },
      },
      commands = {
        nav_to_parent = function(state)
          local node = state.tree:get_node()
          if (node.type == "directory" or node:has_children()) and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        nav_to_child = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" or node:has_children() then
            if not node:is_expanded() then
              state.commands.toggle_node(state)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          elseif node.type == "file" then
            state.commands.open(state)
          end
        end,
        -- Switch to filesystem source
        switch_to_filesystem = function()
          vim.api.nvim_exec("Neotree focus filesystem float", true)
        end,
        -- Switch to buffers source
        switch_to_buffers = function()
          vim.api.nvim_exec("Neotree focus buffers float", true)
        end,
        -- Switch to git_status source
        switch_to_git_status = function()
          vim.api.nvim_exec("Neotree focus git_status float", true)
        end,
        -- Clear search filter when you open a file
        open_and_clear_filter = function(state)
          local node = state.tree:get_node()
          if node and node.type == "file" then
            local file_path = node:get_id()
            -- reuse built-in commands to open and clear filter
            local cmds = require("neo-tree.sources.filesystem.commands")
            cmds.open(state)
            cmds.clear_filter(state)
            -- reveal the selected file without focusing the tree
            require("neo-tree.sources.filesystem").navigate(state, state.path, file_path, function() end)
          end
        end,
        -- Open a file or directory using the OS default viewer
        system_open = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          path = vim.fn.shellescape(path)
          if vim.loop.os_uname().sysname == "Linux" then
            -- Linux: open file in default application
            vim.api.nvim_command("silent !xdg-open " .. path)
          elseif vim.loop.os_uname().sysname == "Darwin" then
            -- macOs: open file in default application in the background.
            vim.api.nvim_command("silent !open -g " .. path)
          end
        end,
      },
      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 0,
          with_expanders = nil,
          with_markers = true,
          indent_marker = "│ ",
          last_indent_marker = "╰─ ",
          highlight = "NeoTreeIndentMarker",
        },
        name = {
          trailing_slash = true,
          use_git_status_colors = true,
        },
        -- icon = {
        --   folder_empty = require("shared").misc.folder_empty,
        --   folder_closed = require("shared").misc.folder_closed,
        --   folder_open = require("shared").misc.folder_open,
        --   default = require("shared").misc.file,
        -- },
      },
      -- zk = { follow_current_file = true, window = { mappings = { ["n"] = "change_query" } } },
    },
  },
  {
    -- Read and write files with sudo
    "lambdalisue/suda.vim",
    event = "BufRead",
    cmd = { "SudaRead", "SudaWrite" },
    keys = {
      { "<leader>fs", ":SudaWrite ", desc = "Sudo write file" },
      { "<leader>fS", ":SudaRead ", desc = "Sudo read file" },
    },
  },
  {
    -- Lets you use your favorite terminal file managers
    "is0n/fm-nvim",
    opts = { ui = { float = { border = "rounded", blend = 15 }, mappings = { q = ":q<CR>" } } },
    keys = {
      {
        "<leader>e",
        -- doing it like this makes it so I can open Lf in my dashboard
        function()
          local filename = vim.fn.expand("%")
          vim.cmd([[Lf ]] .. filename)
        end,
        desc = "File manager (Lf)",
      },
    },
  },
  -- {
  --   "stevearc/oil.nvim",
  --   opts = {},
  --   keys = { { "<leader>E", "<cmd>lua require('oil').open()<cr>", desc = "File manager (oil)" } },
  -- },
  -- {
  --   "echasnovski/mini.misc",
  --   version = false,
  --   config = function(_, opts)
  --     require("mini.misc").setup(opts)
  --     require("mini.misc").setup_auto_root()
  --   end,
  -- },
}
