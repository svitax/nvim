return {
  {
    "is0n/fm-nvim",
    opts = { mappings = { q = ":q<CR>" } },
    keys = {
      {
        "<leader>e",
        -- doing it like this makes it so I can open Lf in my dashboard
        function()
          local filename = vim.fn.expand("%")
          vim.cmd([[Lf ]] .. filename)
        end,
        desc = "File manager",
      },
    },
  },
  -- {
  --   -- TODO: replace nvim-genghis with nvim-dired
  --   "chrisgrieser/nvim-genghis",
  --   dependencies = { "stevearc/dressing.nvim", "hrsh7th/nvim-cmp", "hrsh7th/cmp-omni" },
  --   config = function(_, opts)
  --     local cmp = require("cmp")
  --     cmp.setup.filetype("DressingInput", {
  --       sources = cmp.config.sources({ { name = "omni" } }),
  --     })
  --   end,
  --   keys = {
  --     { "<leader>fC", "<cmd>lua require('genghis').duplicateFile()<cr>", desc = "Copy this file" }, -- genghis duplicate
  --     {
  --       "<leader>fD",
  --       -- "<cmd>lua require('genghis').trashFile({trashLocation = '$HOME/.local/share/Trash'})<cr>",
  --       function()
  --         require("genghis").trashFile({ trashLocation = "$HOME/.local/share/Trash" })
  --       end,
  --       desc = "Delete this file (trash)",
  --     },
  --     { "<leader>fN", "<cmd>lua require('genghis').createNewFile()<cr>", desc = "New file" },
  --     { "<leader>fR", "<cmd>lua require('genghis').moveAndRenameFile()<cr>", desc = "Rename/move file" },
  --     -- { "<leader>fS", desc = "Save file as..." }, write file ...
  --     { "<leader>fX", "<cmd>lua require('genghis').chmodx()<cr>", desc = "Make file executable" },
  --     { "<leader>fy", "<cmd>lua require('genghis').copyFilepath()<cr>", desc = "Yank file path" },
  --     { "<leader>fY", "<cmd>lua require('genghis').copyFilename()<cr>", desc = "Yank file name" },
  --     -- { "<leader>cR", "<cmd>lua require('genghis').renameFile()<cr>", desc = "Rename file" },
  --   },
  -- },
  -- { "ellisonleao/dotenv.nvim", opts = { enable_on_load = true, verbose = true } },
  -- {"LinArcX/telescope-env.nvim"}
  -- {
  --   "stevearc/oil.nvim",
  --   opts = {
  --     keymaps = { ["q"] = "actions.close", ["."] = "actions.toggle_hidden", ["="] = "actions.select" },
  --     view_options = { show_hidden = true },
  --     float = {
  --       max_width = math.floor(vim.opt.columns:get() * 0.75),
  --       max_height = math.floor(vim.opt.lines:get() * 0.75),
  --     },
  --   },
  --   keys = { { "<leader>E", "<cmd>Oil --float<cr>", desc = "Files" } },
  -- },
  -- {
  --   "SidOfc/carbon.nvim",
  --   lazy = false,
  --   init = function()
  --     vim.g.carbon_lazy_init = true
  --   end,
  --   opts = {
  --     auto_open = false,
  --     indicators = { expand = "", collapse = "" },
  --     actions = {
  --       up = "l",
  --       down = ";",
  --       quit = "q",
  --       edit = "<cr>",
  --       move = "m",
  --       reset = "u",
  --       split = { "<c-x>", "<c-s>" },
  --       vsplit = "<c-v>",
  --       create = { "c" },
  --       delete = "d",
  --       close_parent = "-",
  --     },
  --     float_settings = function()
  --       local columns = vim.opt.columns:get()
  --       local rows = vim.opt.lines:get()
  --       local width = math.floor(columns * 0.75)
  --       local height = math.floor(rows * 0.75)
  --
  --       return {
  --         relative = "editor",
  --         style = "minimal",
  --         border = "single",
  --         width = width,
  --         height = height,
  --         col = math.floor(columns / 2 - width / 2),
  --         row = math.floor(rows / 2 - height / 2 - 2),
  --       }
  --     end,
  --   },
  --   keys = { { "<leader>E", "<cmd>Fcarbon!<cr>", desc = "Carbon" } },
  -- },
  -- {
  --   "is0n/tui-nvim",
  --   config = function(_, opts)
  --     function Lf()
  --       require("tui-nvim"):new({
  --         cmd = "lf " .. vim.fn.fnameescape(vim.fn.expand("%:p")),
  --         temp = "/tmp/tui-nvim",
  --         method = "float",
  --       })
  --     end
  --     function Lazygit()
  --       require("tui-nvim"):new({
  --         cmd = "lazygit -w " .. vim.fn.fnameescape(vim.fn.expand("%:p:h")),
  --       })
  --     end
  --     vim.cmd([[command! Lazygit :lua Lazygit()<cr>]])
  --     vim.cmd([[command! Lf :lua Lf()<cr>]])
  --   end,
  --   keys = { { "<leader>e", "<cmd>Lf<cr>", desc = "Files" }, { "<leader>gt", "<cmd>Lazygit<cr>", desc = "Lazygit" } },
  -- },
}
