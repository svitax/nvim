return {
  -- TODO: replace nvim-femaco with otter.nvim
  { "AckslD/nvim-FeMaco.lua", config = true, keys = { { "<leader>ne", "<cmd>FeMaco<cr>", desc = "Edit codeblock" } } },
  { "opdavies/toggle-checkbox.nvim", ft = { "markdown" } },
  -- TODO: mind.nvim is deprecated
  {
    "phaazon/mind.nvim",
    opts = { ui = { width = 40 } },
    keys = { { "<leader>nt", "<cmd>MindOpenMain<cr>", desc = "Todos (mind)" } },
  },
  {
    "mickael-menu/zk-nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    name = "zk",
    ft = "markdown",
    opts = { picker = "telescope" },
    -- config = function(_, opts)
    --   require("zk").setup(opts)
    --   require("telescope").load_extension("zk")
    -- end,
    keys = {
      -- Find notes.
      { "<leader>fn", "<cmd>ZkNotes { sort = {'modified'}}<cr>", desc = "Find notes" },
      { "<leader>nn", "<cmd>ZkNotes { sort = {'modified'}}<cr>", desc = "Find notes" },
      -- Search for the notes matching the current visual selection.
      { "<leader>nF", "<cmd><,'>ZkMatch<cr>", mode = "v", desc = "Find note (selection)" },
      -- "Refresh zk index"
      { "<leader>ni", "<cmd>ZkIndex<cr>", desc = "Refresh index" },
      -- Create a new note after asking for its title.
      { "<leader>nN", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", desc = "New note", silent = false },
      -- Open notes linked by the current buffer.
      { "<leader>nl", "<cmd>ZkLinks<cr>", desc = "Find links" },
      -- Open notes linking to the current buffer.
      { "<leader>nL", "<cmd>ZkBacklinks<cr>", desc = "Find backlinks" },
      -- Open notes associated with the selected tag.
      { "<leader>ng", "<cmd>ZkTags<cr>", desc = "Find tags" },
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
  {
    "nvim-telescope/telescope-bibtex.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("bibtex")
    end,
    keys = {
      -- { "<leader>nb", "<cmd>Telescope bibtex<cr>", desc = "Bibliography" },
      { "<leader>nB", "<cmd>e ~/Dropbox/docs/lib.bib<cr>", desc = "Edit bib file" },
      {
        "<leader>fb",
        function()
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")
          -- local Path = require("plenary.path")
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
                    s = "/home/svitax/Dropbox/docs/" .. (s:match("%{(.-)%}") or s:match("(books/[^\n]+)"))
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
    },
  },
  {
    "gaoDean/autolist.nvim",
    ft = { "markdown", "text", "tex", "plaintex" },
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
      -- TODO: autolist has a bug where it adds a space to the end of new list items
      -- this autocmd (from the readme) makes it so I can't auto-format that away
      -- vim.api.nvim_create_autocmd("TextChanged", {
      --   pattern = "*",
      --   callback = function()
      --     vim.cmd.normal({ autolist.force_recalculate(nil, nil), bang = false })
      --   end,
      -- })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- NOTE: installing zk through mason breaks ZkNew functionality
        -- "zk",
        "markdownlint",
        -- "cbfmt",
        -- "codespell",
        -- "vale",
      }, 0, #opts.ensure_installed)
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      table.insert(
        opts.sources,
        nls.builtins.diagnostics.markdownlint.with({
          extra_args = { "--disable", "trailing-spaces", "no-multiple-blanks", "line-length" },
        })
      )
      -- table.insert(opts.sources, nls.builtins.formatting.cbfmt)
      -- table.insert(opts.sources, nls.builtins.diagnostics.codespell.with({ filetypes = { "text", "markdown" } }))
      -- table.insert(
      --   opts.sources,
      --   nls.builtins.diagnostics.vale.with({
      --     extra_args = { "--config", vim.fn.expand("$HOME") .. "/.config/vale/.vale.ini" },
      --   })
      -- )
      -- table.insert(
      --   opts.sources,
      --   nls.builtins.formatting.markdownlint.with({
      --     extra_args = { "--disable", "trailing-spaces", "no-multiple-blanks", "line-length" },
      --   })
      -- )
    end,
  },
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
  -- {
  --   "bennypowers/nvim-regexplainer",
  --   cmd = { "RegexplainerShowSplit", "RegexplainerShowPopup", "RegexplainerToggle" },
  --   opts = { mappings = { toggle = false } },
  --   keys = {
  --     {
  --       "<leader>nE",
  --       function()
  --         return require("regexplainer").toggle({ display = "popup" })
  --       end,
  --       desc = "Regexplainer",
  --     },
  --   },
  -- },
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = function(_, opts)
  --     if type(opts.ensure_installed) == "table" then
  --       vim.list_extend(opts.ensure_installed, { "regex" })
  --     end
  --   end,
  -- },
  -- { "lukas-reineke/headlines.nvim", ft = { "markdown" }, config = true },
}
