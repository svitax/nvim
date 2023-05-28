return {
  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Location list" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix list" },
      { "<leader>xQ", false },
      { "<leader>xL", false },
    },
    opts = { use_diagnostic_signs = true },
  },
}
