return {
  { "yorickpeterse/nvim-pqf", event = "VeryLazy", ft = "qf", opts = {} },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    cmd = "BqfAutoToggle",
    event = "QuickFixCmdPost",
    -- init = function()
    --   -- format quickfix appearance
    --   -- vim.o.qftf = "{info -> v:lua._G.qftf(info)}"
    --   vim.o.quickfixtextfunc = [[{info -> v:lua.require('utils').qftf(info)}]]
    -- end,
    keys = {
      { "<leader>xF", "<cmd>BqfAutoToggle<cr>", desc = "Toggle nvim-bqf" },
      { "<leader>xQ", "<cmd>copen<cr>", desc = "Quickfix list (vim)" },
    },
    opts = {
      preview = {
        win_height = 12,
        win_vheight = 12,
        auto_preview = true,
        should_preview_cb = function(bufnr)
          -- file size greater than 100kb can't be previewed automatically
          local filename = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(filename)
          if fsize > 100 * 1024 then
            return false
          end
          return true
        end,
      },
      filter = { fzf = { extra_opts = { "--bind", "ctrl-o:toggle-all", "--delimiter", "│" } } },
    },
  },
  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Location list (trouble)" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix list (trouble)" },
      { "<leader>xQ", false },
      { "<leader>xL", false },
    },
    opts = { use_diagnostic_signs = true },
  },
}
