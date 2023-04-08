return {
  -- { "ldelossa/buffertag", event = "BufReadPost", opts = {} },
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      override = {
        [".luacheckrc"] = { icon = "", color = "#51a0cf", cterm_color = "74", name = "Luacheck" },
        -- NOTE: Cargo.toml and Cargo.lock don't work
        ["Cargo.toml"] = { icon = "", color = "#d28446", name = "CargoToml" },
        ["Cargo.lock"] = { icon = "", color = "#d28446", name = "CargoLock" },
        -- NOTE: fish color doesn't show in telescope
        fish = { icon = "󰈺", color = "#6a9fb5", name = "Fish" },
        ["go.mod"] = { icon = "ﳑ", color = "#6a9fb5", name = "Mod" },
        ["go.sum"] = { icon = "ﳑ", color = "#6a9fb5", name = "Sum" },
        yaml = { icon = "", color = "#e8274b", name = "Yaml" },
        yml = { icon = "", color = "#e8274b", name = "Yml" },
        tf = { icon = "󱁢", color = "#5F43E9", name = "Terraform" },
        tex = { icon = "", color = "#3D6117", name = "Tex" },
        md = { icon = "", color = "#519aba", name = "Markdown" },
        rmd = { icon = "", color = "#519aba", name = "RMarkdown" },
        png = { icon = "", color = "#a074c4", name = "Png" },
        nim = { icon = "󰆥", color = "#f3d400", name = "Nim" },
        gql = { icon = "", color = "#e535ab", name = "GraphQL" },
        graphql = { icon = "", color = "#e535ab", name = "GraphQL" },
        godot = { icon = "", color = "#6d8086", name = "Godot" },
        env = { icon = "", color = "#faf743", name = "Env" },
        node_modules = { icon = "", color = "#E8274B", name = "NodeModules" },
        ["package.json"] = { icon = "", color = "#e8274b", name = "PackageJson" },
        ["package-lock.json"] = { icon = "", color = "#7a0d21", name = "PackageLockJson" },
        ["LICENSE"] = { icon = "", color = "#d0bf41", name = "License" },
      },
      -- override_by_extension = {},
      -- override_by_filename = {},
    },
  },
  {
    "stevearc/dressing.nvim",
    opts = { select = { telescope = require("telescope.themes").get_ivy { ... } } },
  },
  {
    "folke/which-key.nvim",
    opts = { key_labels = { ["<space>"] = "<spc>", ["<cr>"] = "<ret>" } },
    config = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts)
      wk.register {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["ga"] = { name = "+text case" },
        ["ge"] = { name = "+text case op" },
        -- ["gz"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>d"] = { name = "+debug" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunks" },
        ["<leader>h"] = { name = "+help" },
        ["<leader>m"] = { name = "+<localleader>" },
        ["<leader>n"] = { name = "+notes" },
        ["<leader>p"] = { name = "+project" },
        -- ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>so"] = { name = "+online" },
        ["<leader>t"] = { name = "+test" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      }
    end,
  },
  {
    "folke/noice.nvim",
    -- enabled = false,
    opts = {
      messages = {
        enabled = true,
        view = "mini",
        view_warn = "mini",
        view_error = "mini",
        view_history = "messages",
        view_search = false,
      },
      cmdline = {
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
        { filter = { event = "msg_show", kind = "echo", find = "%w%w%w%w%w%w%w " }, opts = { skip = true } },
        -- { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
        -- { view = "notify", filter = { event = "msg_showmode" } },
      },
      lsp = {
        progress = { enabled = true },
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
      notify = { enabled = true, view = "mini" },
      views = { cmdline_popup = { position = { row = 0, col = "50%" }, size = { width = "98%" } } },
      presets = {
        bottom_search = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
        command_palette = false,
      },
      popupmenu = { backend = "cmp" },
    },
    keys = {
      { "<leader>sna", false },
      { "<leader>snh", false },
      { "<leader>snl", false },
      {
        "<c-d>",
        function()
          local t = function(str)
            return vim.api.nvim_replace_termcodes(str, true, true, true)
          end

          if not require("noice.lsp").scroll(4) then
            vim.api.nvim_feedkeys(t "<c-d>", "n", true)
          end
        end,
        desc = "Scroll down",
      },
      {
        "<c-u>",
        function()
          local t = function(str)
            return vim.api.nvim_replace_termcodes(str, true, true, true)
          end

          if not require("noice.lsp").scroll(-4) then
            vim.api.nvim_feedkeys(t "<c-u>", "n", true)
          end
        end,
        desc = "Scroll up",
      },
    },
  },
}
