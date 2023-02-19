return {
  {
    "goolord/alpha-nvim",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
███████╗███████╗███╗   ██╗███╗   ██╗███████╗ ██████╗
██╔════╝██╔════╝████╗  ██║████╗  ██║██╔════╝██╔════╝
█████╗  █████╗  ██╔██╗ ██║██╔██╗ ██║█████╗  ██║     
██╔══╝  ██╔══╝  ██║╚██╗██║██║╚██╗██║██╔══╝  ██║     
██║     ███████╗██║ ╚████║██║ ╚████║███████╗╚██████╗
╚═╝     ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝ ╚═════╝
]]
      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        -- dashboard.button("f", " " .. " Find file", "<cmd>Telescope find_files<cr>"),
        -- dashboard.button("s", "勒" .. " Restore Session", [[:lua require("persistence").load()<cr>]]),
        -- dashboard.button("z", " " .. " Zshrc", ":e ~/.zshrc | :cd %:p:h<CR>"),
        dashboard.button("f", " " .. " Find file", [[:lua require('lazyvim.util').telescope('files')()<cr>]]),
        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert<cr>"),
        dashboard.button("p", " " .. " Projects", [[:lua require('telescope').extensions.repo.list()<cr>]]),
        dashboard.button(
          "r",
          " " .. " Recent files",
          [[:lua require('telescope').extensions.recent_files.pick()<cr>]]
        ),
        dashboard.button("g", " " .. " Find text", [[:lua require('lazyvim.util').telescope('live_grep')()<cr>]]),
        dashboard.button("l", "鈴" .. " Plugins", ":Lazy<cr>"),
        dashboard.button("c", " " .. " Configuration", ":e $MYVIMRC<cr>"),
        dashboard.button("q", " " .. " Quit", ":qa<cr>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
  },
}
