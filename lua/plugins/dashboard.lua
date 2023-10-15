return {
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      local logo = [[
███████╗███████╗███╗   ██╗███╗   ██╗███████╗ ██████╗
██╔════╝██╔════╝████╗  ██║████╗  ██║██╔════╝██╔════╝
█████╗  █████╗  ██╔██╗ ██║██╔██╗ ██║█████╗  ██║     
██╔══╝  ██╔══╝  ██║╚██╗██║██║╚██╗██║██╔══╝  ██║     
██║     ███████╗██║ ╚████║██║ ╚████║███████╗╚██████╗
╚═╝     ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝ ╚═════╝
    ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          -- stylua: ignore
          center = {
            { action = [[:lua require('lazyvim.util').telescope('files')()]], desc = " Find file", icon = " ", key = "f" },
            { action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
            { action = [[:lua require('telescope').extensions.repo.list()]], desc = " Projects", icon = " ", key = "p" },
            { action = [[:lua require('telescope').extensions.smart_open.smart_open()]], desc = " Recent files", icon = " ", key = "r" },
            { action = [[:lua require('lazyvim.util').telescope('live_grep')()]], desc = " Find text", icon = " ", key = "g" },
            { action = "e $MYVIMRC", desc = " Config", icon = " ", key = "c" },
            { action = "LazyExtras", desc = " Lazy extras", icon = " ", key = "E" },
            { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "P" },
            { action = "qa", desc = " Quit", icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      end

      for _, button in ipairs(opts.config.center) do
        button.icon_hl = "DashboardIcon"
        button.key_hl = "DashboardKey"
        button.desc_hl = "DashboardDesc"
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      return opts
    end,
  },
  --   {
  --     "goolord/alpha-nvim",
  --     opts = function()
  --       local dashboard = require("alpha.themes.dashboard")
  --       local logo = [[
  -- ███████╗███████╗███╗   ██╗███╗   ██╗███████╗ ██████╗
  -- ██╔════╝██╔════╝████╗  ██║████╗  ██║██╔════╝██╔════╝
  -- █████╗  █████╗  ██╔██╗ ██║██╔██╗ ██║█████╗  ██║
  -- ██╔══╝  ██╔══╝  ██║╚██╗██║██║╚██╗██║██╔══╝  ██║
  -- ██║     ███████╗██║ ╚████║██║ ╚████║███████╗╚██████╗
  -- ╚═╝     ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝ ╚═════╝
  -- ]]
  --       dashboard.section.header.val = vim.split(logo, "\n")
  --       dashboard.section.buttons.val = {
  --         -- dashboard.button("f", " " .. " Find file", "<cmd>Telescope find_files<cr>"),
  --         -- dashboard.button("s", "勒" .. " Restore Session", [[:lua require("persistence").load()<cr>]]),
  --         -- dashboard.button("z", " " .. " Zshrc", ":e ~/.zshrc | :cd %:p:h<CR>"),
  --         dashboard.button("f", " " .. " Find file", [[:lua require('lazyvim.util').telescope('files')()<cr>]]),
  --         dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert<cr>"),
  --         dashboard.button("p", " " .. " Projects", [[:lua require('telescope').extensions.repo.list()<cr>]]),
  --         -- dashboard.button(
  --         --   "r",
  --         --   " " .. " Recent files",
  --         --   [[:lua require('telescope').extensions.recent_files.pick()<cr>]]
  --         -- ),
  --         dashboard.button(
  --           "r",
  --           " " .. " Recent files",
  --           [[:lua require('telescope').extensions.smart_open.smart_open()<cr>]]
  --         ),
  --         dashboard.button("g", " " .. " Find text", [[:lua require('lazyvim.util').telescope('live_grep')()<cr>]]),
  --         dashboard.button("l", "鈴" .. " Plugins", ":Lazy<cr>"),
  --         dashboard.button("c", " " .. " Configuration", ":e $MYVIMRC<cr>"),
  --         dashboard.button("q", " " .. " Quit", ":qa<cr>"),
  --       }
  --       for _, button in ipairs(dashboard.section.buttons.val) do
  --         button.opts.hl = "AlphaButtons"
  --         button.opts.hl_shortcut = "AlphaShortcut"
  --       end
  --       dashboard.section.footer.opts.hl = "AlphaFooter"
  --       dashboard.section.header.opts.hl = "AlphaHeader"
  --       dashboard.section.buttons.opts.hl = "AlphaButtons"
  --       dashboard.opts.layout[1].val = 8
  --       return dashboard
  --     end,
  --   },
}
