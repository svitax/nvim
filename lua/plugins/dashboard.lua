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
        dashboard.button("f", " " .. " Find file", "<cmd>Telescope find_files<cr>"),
        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert<cr>"),
        dashboard.button(
          "r",
          " " .. " Recent files",
          "<cmd>lua require('telescope').extensions.recent_files.pick()<cr>"
        ),
        dashboard.button("g", " " .. " Find text", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("c", " " .. " Config", ":e $MYVIMRC<cr>"),
        dashboard.button("s", "勒" .. " Restore Session", [[:lua require("persistence").load()<cr>]]),
        dashboard.button("l", "鈴" .. " Lazy", ":Lazy<cr>"),
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
