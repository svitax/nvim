return {
  { "nvim-telescope/telescope-bibtex.nvim" },
  {
    "mickael-menu/zk-nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    name = "zk",
    ft = "markdown",
    opts = {
      picker = "telescope",
    },
    -- config = function(_, opts)
    --   require("zk").setup(opts)
    --   require("telescope").load_extension("zk")
    -- end,
    keys = {
      -- Find bibliography
      -- {
      --   "<leader>nb",
      --   lv_utils.telescope("files", {
      --     attach_mappings = function(prompt_bufnr, map)
      --       require("telescope.actions").select_default:replace(function()
      --         local function get_selected_files(smart)
      --           smart = vim.F.if_nil(smart, true)
      --           local selected = {}
      --           local current_picker = action_state.get_current_picker(prompt_bufnr)
      --           local selections = current_picker:get_multi_selection()
      --           if smart and vim.tbl_isempty(selections) then
      --             table.insert(selected, action_state.get_selected_entry())
      --           else
      --             for _, selection in ipairs(selections) do
      --               table.insert(selected, Path:new(selection[1]))
      --             end
      --           end
      --           selected = vim.tbl_map(function(entry)
      --             return Path:new(entry.path)
      --           end, selected)
      --           return selected
      --         end
      --         local selections = get_selected_files(true)
      --
      --         if vim.tbl_isempty(selections) then
      --           vim.notify("No selection to be opened!")
      --           return
      --         end
      --
      --         local cmd = vim.fn.has("win32") == 1 and "start" or vim.fn.has("mac") == 1 and "open" or "xdg-open"
      --         for _, selection in ipairs(selections) do
      --           require("plenary.job")
      --             :new({
      --               command = cmd,
      --               args = { selection:absolute() },
      --             })
      --             :start()
      --         end
      --         actions.close(prompt_bufnr)
      --       end)
      --       return true
      --     end,
      --     cwd = "~/Desktop/docs/books",
      --   }),
      --   desc = "Bibliography",
      -- },
      -- Find notes.
      { "<leader>fn", "<cmd>ZkNotes { sort = {'modified'}}<cr>", desc = "Find notes" },
      { "<leader>nn", "<cmd>ZkNotes { sort = {'modified'}}<cr>", desc = "Find notes" },
      -- Search for the notes matching the current visual selection.
      { "<leader>nF", "<cmd><,'>ZkMatch<cr>", mode = "v", desc = "Find note (selection)" },
      -- "Refresh zk index"
      { "<leader>ni", "<cmd>ZkIndex<cr>", desc = "Refresh index" },
      -- Create a new note after asking for its title.
      { "<leader>nN", "<cmd>ZkNew {title = vim.fn.input('Title: ')}<cr>", desc = "New note" },
      -- Open notes linked by the current buffer.
      { "<leader>nl", "<cmd>ZkLinks<cr>", desc = "Find links" },
      -- Open notes linking to the current buffer.
      { "<leader>nL", "<cmd>ZkBacklinks<cr>", desc = "Find backlinks" },
      -- Open notes associated with the selected tag.
      { "<leader>nt", "<cmd>ZkTags<cr>", desc = "Find tags" },
      -- Create a new note in the same directory as the current buffer, using the current selection for title.
      {
        "<leader>nT",
        ":'<,'>ZkNewFromTitleSelection<CR>",
        mode = "v",
        desc = "New note with selection as title",
      },
      -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
      {
        "<leader>nC",
        ":'<,'>ZkNewFromContentSelection { title = vim.fn.input('Title: ') }<CR>",
        mode = "v",
        desc = "New note with selection as content",
      },
    },
  },
  -- TODO: cbfmt support
  -- {
  --   "williamboman/mason.nvim",
  --   opts = function(_, opts)
  --     vim.list_extend(opts.ensure_installed, {
  --       "cbfmt",
  --     }, 0, #opts.ensure_installed)
  --   end,
  -- },
  -- {
  --   "jose-elias-alvarez/null-ls.nvim",
  --   opts = function(_, opts)
  --     local nls = require("null-ls")
  --     table.insert(opts.sources, nls.builtins.formatting.cbfmt)
  --   end,
  -- },
  {
    "gaoDean/autolist.nvim",
    ft = {
      "markdown",
      "text",
      "tex",
      "plaintex",
    },
    config = function()
      local autolist = require("autolist")
      autolist.setup()
      autolist.create_mapping_hook("i", "<CR>", autolist.new)
      autolist.create_mapping_hook("i", "<Tab>", autolist.indent)
      autolist.create_mapping_hook("i", "<S-Tab>", autolist.indent, "<C-D>")
      autolist.create_mapping_hook("n", "o", autolist.new)
      autolist.create_mapping_hook("n", "O", autolist.new_before)
      autolist.create_mapping_hook("n", ">>", autolist.indent)
      autolist.create_mapping_hook("n", "<<", autolist.indent)
      autolist.create_mapping_hook("n", "<C-r>", autolist.force_recalculate)
      autolist.create_mapping_hook("n", "<leader>x", autolist.invert_entry, "")
      vim.api.nvim_create_autocmd("TextChanged", {
        pattern = "*",
        callback = function()
          vim.cmd.normal({ autolist.force_recalculate(nil, nil), bang = false })
        end,
      })
    end,
  },
  -- TODO: toggle-checkbox support
  { "opdavies/toggle-checkbox.nvim", ft = { "markdown" } },
  -- TODO: add glow.nvim when it has support for live split preview
  -- https://github.com/ellisonleao/glow.nvim/discussions/78
  -- {"ellisonleao/glow.nvim", config = true, cmd = "Glow"}
  -- TODO: lyaml as a rocks dependency (not supported by lazy.nvim)
  -- {
  --   "jghauser/papis.nvim",
  --   dependencies = { "kkharji/sqlite.lua" },
  --   cmd = "PapisStart",
  --   opts = { enable_keymaps = false },
  --   config = function(_, opts)
  --     require("papis").setup(opts)
  --     require("telescope").load_extension("papis")
  --   end,
  --   keys = {
  --     { "<leader>np", "<cmd>Telescope papis<cr>", desc = "Bibliography (papis)" },
  --   },
  -- },
}
