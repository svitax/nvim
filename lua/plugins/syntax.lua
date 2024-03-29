return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter-textobjects",
      "nvim-treesitter/playground",
      -- wisely add "end" in ruby, lua, vimscript, etc. treesitter aware.
      "RRethy/nvim-treesitter-endwise",
      -- Sticky headers
      { "nvim-treesitter/nvim-treesitter-context", opts = { max_lines = 4 } },
      {
        "andymass/vim-matchup",
        event = "BufReadPost", -- other lazyloading methods do not seem to work
        init = function()
          vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
          vim.g.matchup_text_obj_enabled = 0
          vim.g.matchup_matchparen_enabled = 1
        end,
      },
      {
        "sustech-data/wildfire.nvim",
        opts = { keymaps = { init_selection = "<CR>", node_incremental = "<CR>", node_decremental = "<BS>" } },
      },
    },
    opts = {
      highlight = { enable = true, additional_vim_regex_highlighting = { "markdown" } },
      endwise = { enable = true }, -- See: https://github.com/RRethy/nvim-treesitter-endwise
      -- indent = { enable = false },
      indent = { enable = true, disable = { "yaml", "python", "typescriptreact", "typescript", "lua" } },
      -- incremental_selection = {
      --   enable = true,
      --   keymaps = {
      --     init_selection = "<CR>",
      --     node_incremental = "<CR>",
      --     scope_incremental = false,
      --     -- scope_incremental = "<S-CR>",
      --     node_decremental = "<S-CR>",
      --   },
      -- },
      matchup = { enable = true, include_match_words = true, enable_quotes = true }, -- See: https://github.com/andymass/vim-matchup
      playground = { enable = true },
      -- refactor = { highlight_definitions = { enable = true }, highlight_current_scope = { enable = true } },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["a,"] = "@parameter.outer",
            ["i,"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["],"] = "@parameter.inner",
          },
          goto_previous_start = {
            ["[,"] = "@parameter.inner",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            [">,"] = "@parameter.inner",
          },
          swap_previous = {
            ["<,"] = "@parameter.inner",
          },
        },
      },
    },
  },
  -- { "MTDL9/vim-log-highlighting", ft = "log" },
  -- { "lark-parser/vim-lark-syntax", ft = "lark" },
  {
    "echasnovski/mini.trailspace",
    event = { "BufReadPost", "BufNewFile" },
    main = "mini.trailspace",
    opts = { blacklist = { "lazy" } },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = opts.blacklist,
        callback = function()
          vim.b.minitrailspace_disable = true
          MiniTrailspace.unhighlight() -- force an update?
          -- vim.schedule(MiniTrailspace.unhighlight)
        end,
      })

      require("mini.trailspace").setup()
    end,
  },
  -- Automatically set correct indent for file
  { "NMAC427/guess-indent.nvim", event = "BufReadPre", opts = { override_editorconfig = false } },
  -- Dim unused variables
  {
    -- BUG: Newest versions requires nvim 0.10
    "zbirenbaum/neodim",
    branch = "v2",
    event = "LspAttach",
    opts = { alpha = 0.60, update_in_insert = { enable = false } },
  },
  -- Highlight arguments' definitions and usages
  {
    "m-demare/hlargs.nvim",
    dependencies = { "nvim-treesitter" },
    event = "BufReadPost",
    -- event = "VeryLazy",
    opts = {
      paint_arg_declarations = false,
      paint_catch_blocks = { declarations = false, usages = true },
      extras = { named_parameters = false },
    },
  },
  {
    "chrisgrieser/nvim-puppeteer",
    ft = {
      "python", --[["javascript", "typescript", "typescriptreact", "javascriptreact"]]
    },
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "folke/todo-comments.nvim",
    opts = { signs = false, highlight = { after = "" } },
    keys = {
      -- stylua: ignore
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      -- stylua: ignore
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      {
        "<leader>xt",
        function()
          local command = "TodoTrouble cwd=" .. vim.fn.expand("%:p:h")
          vim.api.nvim_command(command)
        end,
        desc = "Todo trouble (cwd)",
      },
      {
        "<leader>xT",
        function()
          local command = "TodoTrouble keywords=TODO,FIX,FIXME cwd=" .. vim.fn.expand("%:p:h")
          vim.api.nvim_command(command)
        end,
        desc = "Todo/Fix/Fixme (cwd)",
      },
      {
        "<leader>sT",
        function()
          local command = "TodoTelescope cwd=" .. vim.fn.expand("%:p:h")
          vim.api.nvim_command(command)
        end,
        desc = "Search todo (cwd)",
      },
      { "<leader>sT", false },
    },
  },
}
