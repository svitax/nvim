-- local shared = require("shared")ui

return {
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      override = {
        -- NOTE: Cargo.toml and Cargo.lock don't work
        ["Cargo.toml"] = { icon = "", color = "#d28446", name = "CargoToml" },
        ["Cargo.lock"] = { icon = "", color = "#d28446", name = "CargoLock" },
        env = { icon = "", color = "#d0bf41", name = "Env" },
        [".eslintrc"] = { icon = "󰱺", color = "#8080f2", name = "Eslint" },
        [".eslintignore"] = { icon = "󰱺", color = "#8080f2", name = "Eslint" },
        [".eslintcache"] = { icon = "󰱺", color = "#8080f2", name = "Eslint" },
        [".eslintrc.js"] = { icon = "󰱺", color = "#8080f2", name = "Eslint" },
        [".eslintrc.cjs"] = { icon = "󰱺", color = "#8080f2", name = "Eslint" },
        [".eslintrc.ts"] = { icon = "󰱺", color = "#8080f2", name = "Eslint" },
        [".eslintrc.yaml"] = { icon = "󰱺", color = "#8080f2", name = "Eslint" },
        [".eslintrc.yml"] = { icon = "󰱺", color = "#8080f2", name = "Eslint" },
        [".eslintrc.json"] = { icon = "󰱺", color = "#8080f2", name = "Eslint" },
        ["eslint.config.js"] = { icon = "󰱺", color = "#8080f2", name = "Eslint" },
        -- NOTE: fish color doesn't show in telescope
        fish = { icon = "󰈺", color = "#73a3b7", name = "Fish" },
        ["fish_plugins"] = { icon = "󰈺", color = "#73a3b7", name = "Fish" },
        ["fish_variables"] = { icon = "󰈺", color = "#73a3b7", name = "Fish" },
        ["go.mod"] = { icon = "ﳑ", color = "#73a3b7", name = "Mod" },
        ["go.sum"] = { icon = "ﳑ", color = "#73a3b7", name = "Sum" },
        gql = { icon = "", color = "#e00097", name = "GraphQL" },
        graphql = { icon = "", color = "#e00097", name = "GraphQL" },
        godot = { icon = "", color = "#6d8086", name = "Godot" },
        js = { icon = "", color = "#d8a657", name = "JS" },
        cjs = { icon = "", color = "#d9a657", name = "JS" },
        mjs = { icon = "", color = "#d9a657", name = "JS" },
        jsx = { icon = "ﰆ", color = "#519aba", name = "JSX" },
        ["LICENSE"] = { icon = "", color = "#d8a657", name = "License" },
        [".luacheckrc"] = { icon = "", color = "#51a0cf", cterm_color = "74", name = "Luacheck" },
        md = { icon = "", color = "#73a3b7", name = "Markdown" },
        node_modules = { icon = "", color = "#ea6962", name = "NodeModules" },
        nim = { icon = "󰆥", color = "#d8a657", name = "Nim" },
        png = { icon = "", color = "#b97490", name = "Png" },
        ["package.json"] = { icon = "", color = "#a9b665", name = "PackageJson" },
        ["package-lock.json"] = { icon = "", color = "#a9b665", name = "PackageLockJson" },
        prettierrc = { icon = "", color = "#334651", name = "Prettier" },
        [".prettierrc.json"] = { icon = "", color = "#334651", name = "Prettier" },
        [".prettierrc.yml"] = { icon = "", color = "#334651", name = "Prettier" },
        [".prettierrc.yaml"] = { icon = "", color = "#334651", name = "Prettier" },
        [".prettierrc.json5"] = { icon = "", color = "#334651", name = "Prettier" },
        [".prettierrc.js"] = { icon = "", color = "#334651", name = "Prettier" },
        [".prettierrc.cjs"] = { icon = "", color = "#334651", name = "Prettier" },
        [".prettier.toml"] = { icon = "", color = "#334651", name = "Prettier" },
        ["prettier.config.js"] = { icon = "", color = "#334651", name = "Prettier" },
        ["prettier.config.cjs"] = { icon = "", color = "#334651", name = "Prettier" },
        ipynb = { icon = "", color = "#ffbc03", name = "Jupyter" },
        qmd = { icon = "", color = "#73a3b7", name = "Prettier" },
        ["README"] = { icon = "", color = "#73a3b7", name = "README" },
        rmd = { icon = "", color = "#73a3b7", name = "RMarkdown" },
        stylelintrc = { icon = "", color = "#ffffff", name = "Stylelint" },
        [".stylelintrc.js"] = { icon = "", color = "#ffffff", name = "Stylelint" },
        [".stylelintrc.ts"] = { icon = "", color = "#ffffff", name = "Stylelint" },
        [".stylelintrc.cjs"] = { icon = "", color = "#ffffff", name = "Stylelint" },
        [".stylelintrc.yaml"] = { icon = "", color = "#ffffff", name = "Stylelint" },
        [".stylelintrc.yml"] = { icon = "", color = "#ffffff", name = "Stylelint" },
        ["stylelint.config.js"] = { icon = "", color = "#ffffff", name = "Stylelint" },
        ["stylelint.config.cjs"] = { icon = "", color = "#ffffff", name = "Stylelint" },
        ["svelte.config.js"] = { icon = "", color = "#ff3e00", name = "Svelte" },
        ["svelte.config.cjs"] = { icon = "", color = "#ff3e00", name = "Svelte" },
        ts = { icon = "ﯤ", color = "#519aba", name = "TS" },
        tsx = { icon = "ﰆ", color = "#519aba", name = "TSX" },
        ["tailwind.config.js"] = { icon = "󱏿", color = "#38bdf8", name = "Tailwind" },
        ["tailwind.config.ts"] = { icon = "󱏿", color = "#38bdf8", name = "Tailwind" },
        ["tailwind.config.cjs"] = { icon = "󱏿", color = "#38bdf8", name = "Tailwind" },
        tex = { icon = "", color = "#3D6117", name = "Tex" },
        tf = { icon = "󱁢", color = "#5F43E9", name = "Terraform" },
        yaml = { icon = "", color = "#e8274b", name = "Yaml" },
        yml = { icon = "", color = "#e8274b", name = "Yml" },
        [".yarnrc"] = { icon = "", color = "#73a3b7", name = "Yarn" },
        [".yarnrc.yml"] = { icon = "", color = "#73a3b7", name = "Yarn" },
        [".yarnrc.yaml"] = { icon = "", color = "#73a3b7", name = "Yarn" },
      },
      -- override_by_extension = {},
      -- override_by_filename = {},
    },
  },
  {
    -- TODO: kinda jittery. look into fixing that
    "luukvbaal/statuscol.nvim",
    event = "UIEnter",
    -- event = "VeryLazy",
    opts = function()
      local builtin = require("statuscol.builtin")
      ---To display pretty fold's icons in `statuscolumn` and show it according to `fillchars`
      local function foldcolumn()
        local chars = vim.opt.fillchars:get()
        local fc = "%#FoldColumn#"
        local clf = "%#CursorLineFold#"
        local hl = vim.fn.line(".") == vim.v.lnum and clf or fc
        local text = " "

        if vim.fn.foldlevel(vim.v.lnum) > vim.fn.foldlevel(vim.v.lnum - 1) then
          if vim.fn.foldclosed(vim.v.lnum) == -1 then
            text = hl .. (chars.foldopen or " ")
          else
            text = hl .. (chars.foldclose or " ")
          end
        elseif vim.fn.foldlevel(vim.v.lnum) == 0 then
          text = hl .. " "
        else
          text = hl .. (chars.foldsep or " ")
        end

        return text
      end
      return {
        -- setopt = true,
        relculright = true,
        segments = {
          { sign = { name = { "GitSigns" }, mawidth = 1 }, click = "v:lua.ScSa" },
          -- { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
          -- { sign = { name = { "Diagnostic", "DapBreakpoint" }, maxwidth = 1 }, click = "v:lua.ScSa" },
          { sign = { name = { ".*" }, maxwidth = 1 }, click = "v:lua.ScSa" },
          { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
          { text = { foldcolumn, " " }, click = "v:lua.ScFa" },
        },
      }
    end,
  },
  { "Bekaboo/deadcolumn.nvim", event = "VeryLazy", config = true, opts = { warning = { colorcode = "#ea6962" } } },
  {
    "shellRaining/hlchunk.nvim",
    event = { "UIEnter" },
    opts = {
      exclude_filetypes = {
        NeogitStatus = true,
        NeogitCommitMessage = true,
        NeogitConsole = true,
        toggleterm = true,
      },
      chunk = { style = "#d4879c", notify = false },
      indent = { enable = false },
      line_num = { enable = false },
      blank = { enable = false },
    },
  },
  {
    "stevearc/dressing.nvim",
    opts = { select = { telescope = require("telescope.themes").get_ivy({ ... }) }, input = { enabled = false } },
  },
  -- {
  --   "FeiyouG/commander.nvim",
  --   dependencies = { "nvim-telescope/telescope.nvim" },
  --   opts = {
  --     integration = {
  --       lazy = { enable = true },
  --       -- telescope = { enable = true, theme = require("telescope.themes").get_ivy },
  --     },
  --   },
  --   keys = { { "<leader>hk", "<cmd>lua require('commander').show()<cr>", desc = "Show keymaps" } },
  -- },
  {
    "Cassin01/wf.nvim",
    event = "VeryLazy",
    config = function()
      require("wf").setup({ theme = "space" })
      local which_key = require("wf.builtin.which_key")
      local register = require("wf.builtin.register")
      -- local bookmark = require("wf.builtin.bookmark")
      local mark = require("wf.builtin.mark")

      vim.keymap.set("n", "'", mark(), { nowait = true, noremap = true, silent = true, desc = "[wf.nvim] mark" })
      vim.keymap.set(
        "n",
        '"',
        register(),
        { nowait = true, noremap = true, silent = true, desc = "[wf.nvim] register" }
      )
      vim.keymap.set(
        "n",
        "<leader>",
        which_key({
          -- selector = "fuzzy",
          text_insert_in_advance = "<Space>",
          key_group_dict = {
            -- ["g"] = "goto",
            -- ["ga"] = "text case",
            -- ["ge"] = "text case op",
            -- ["gz"] = "surround",
            -- ["]"] = "next",
            -- ["["] = "prev",
            -- ["<Space><tab>"] = "tabs",
            ["<Space>a"] = "ai",
            ["<Space>b"] = "buffer",
            -- ["<Space>bx"] = "scratch",
            ["<Space>c"] = "code",
            ["<Space>d"] = "debug",
            ["<Space>f"] = "file/find",
            ["<Space>g"] = "git",
            -- ["<leader>gh"] = { name = "+hunks" },
            ["<Space>h"] = "help",
            ["<Space>hd"] = "devdocs",
            ["<Space>m"] = "<localleader>",
            ["<Space>me"] = "evaluate",
            ["<Space>mj"] = "jqx",
            -- ["<Space>ml"] = "logs",
            -- ["<Space>mg"] = "goto",
            -- ["<leader>mr"] = { name = "+reset" },
            ["<Space>mr"] = "rest",
            -- ["<Space>mc"] = "python repl",
            -- ["<Space>mei"] = "interrupt command",
            ["<Space>n"] = "notes",
            ["<Space>p"] = "project",
            ["<Space>q"] = "+quit/session",
            ["<Space>s"] = "search",
            -- ["<leader>so"] = { name = "+online" },
            ["<Space>t"] = "test",
            ["<Space>u"] = "ui",
            ["<Space>w"] = "windows",
            ["<Space>x"] = "diagnostics/quickfix",
            ["<Space>y"] = "yank",
            ["<Space>z"] = "leetcode",
          },
        }),
        { noremap = true, silent = true, desc = "[wf.nvim] which-key <leader>" }
      )
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    enabled = false,
    opts = {
      key_labels = { ["<space>"] = "<spc>", ["<cr>"] = "<ret>" },
      defaults = {
        ["g"] = { name = "+goto" },
        ["ga"] = { name = "+text case" },
        ["ge"] = { name = "+text case op" },
        -- ["gz"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>a"] = { name = "+ai" },
        ["<leader>bx"] = { name = "+scratch" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>d"] = { name = "+debug" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        -- ["<leader>gh"] = { name = "+hunks" },
        ["<leader>h"] = { name = "+help" },
        ["<leader>hd"] = { name = "+devdocs" },
        ["<leader>m"] = { name = "+<localleader>" },
        ["<leader>me"] = { name = "+evaluate" },
        ["<leader>mj"] = { name = "+jqx" },
        ["<leader>ml"] = { name = "+logs" },
        ["<leader>mg"] = { name = "+goto" },
        -- ["<leader>mr"] = { name = "+reset" },
        ["<leader>mr"] = { name = "+rest" },
        ["<leader>mc"] = { name = "+python repl" },
        ["<leader>mei"] = { name = "interrupt command" },
        ["<leader>n"] = { name = "+notes" },
        ["<leader>p"] = { name = "+project" },
        -- ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        -- ["<leader>so"] = { name = "+online" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
        ["<leader>y"] = { name = "+yank" },
      },
    },
  },
  { "j-hui/fidget.nvim", tag = "legacy", event = "LspAttach", opts = {} },
  {
    "folke/noice.nvim",
    opts = {
      messages = {
        enabled = false,
        view = "mini",
        view_warn = "mini",
        view_error = "mini",
        view_history = "messages",
        view_search = false,
      },
      cmdline = {
        enabled = true,
        view = "cmdline",
        opts = {
          win_options = {
            winhighlight = {
              Normal = "NormalFloat",
              FloatBorder = "FloatBorder",
            },
          },
        },
      },
      routes = {
        -- tries to hide Twiggy branch detail echo messages by trying to match a SHA1 of 7 chars and a space
        -- { filter = { event = "msg_show", kind = "echo", find = "%w%w%w%w%w%w%w " }, opts = { skip = true } },
        -- { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
        -- { view = "notify", filter = { event = "msg_showmode" } },
        { filter = { event = "msg_show", find = "%d+ lines yanked" }, { opts = { skip = true } } },
        { filter = { event = "msg_show", find = "%d+ more lines" }, { opts = { skip = true } } },
      },
      lsp = {
        -- NOTE: fidget.nvim behaves and looks nicer
        progress = { enabled = false },
        hover = {
          enabled = true,
          view = "cmdline",
          opts = {
            enter = false,
            size = {
              height = "auto",
              max_height = 13,
              min_height = 1,
            },
            border = { padding = { top = 1, left = 0 } },
          },
        },

        signature = { enabled = true, view = "cmdline", opts = { size = { height = 1 } } },
      },
      notify = { enabled = true, view = "notify" },
      presets = {
        bottom_search = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
        command_palette = false,
      },
      popupmenu = { backend = "cmp" },
      views = {
        cmdline_popup = { position = { row = 0, col = "50%" }, size = { width = "98%" } },
        -- NOTE: if you have cmdheight>0, mini will overlap with the statusbar.
        -- offset the default row position for mini (-1) by your cmdheight
        mini = { position = { row = -2 } },
        notify = { merge = true, replace = true },
      },
    },
    keys = {
      { "<leader>sna", false },
      { "<leader>snd", false },
      { "<leader>snh", false },
      { "<leader>snl", false },
      -- stylua: ignore
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect cmdline" },
      -- stylua: ignore
      { "<leader>ha", function() require("noice").cmd("all") end, desc = "All messages" },
      { "<leader>he", "<cmd>Noice errors<cr>", desc = "Errors" }, -- noice
      {
        "<leader>hh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Message history",
      },
      -- stylua: ignore
      { "<leader>hl", function() require("noice").cmd("last") end, desc = "Noice last message" },
      -- stylua: ignore
      { "<leader>hm", "<cmd>Noice telescope<cr>", desc = "Search messages" }, -- noice
      {
        "<c-d>",
        -- stylua: ignore
        function() if not require("noice.lsp").scroll(4) then return "<c-d>" end end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-u>",
        -- stylua: ignore
        function() if not require("noice.lsp").scroll(-4) then return "<c-u>" end end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = { "i", "n", "s" },
      },
    },
  },
  {
    "tzachar/highlight-undo.nvim",
    keys = { "u", "<C-r>" },
    opts = {
      duration = 250,
      undo = { hlgroup = "HighlightUndo", mode = "n", lhs = "u", map = "silent undo", opts = { desc = "Undo" } },
      redo = { hlgroup = "HighlightUndo", mode = "n", lhs = "<C-r>", map = "silent redo", opts = { desc = "Redo" } },
    },
  },
  -- { "lewis6991/whatthejump.nvim", keys = { "<c-i>", "<c-o>" } },
}
