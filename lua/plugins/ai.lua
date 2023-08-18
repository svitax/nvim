local modes = { "n", "v" }

return {
  {
    "jackMort/ChatGPT.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>aa", "<cmd>ChatGPTActAs<cr>", desc = "ChatGPT act as" },
      { "<leader>ac", "<cmd>ChatGPT<cr>", desc = "ChatGPT" },
      { "<leader>ad", "<cmd>ChatGPTRun docstring<CR>", desc = "ChatGPT docstring", mode = modes },
      { "<leader>ae", "<cmd>ChatGPTEditWithInstructions<cr>", mode = modes, desc = "ChatGPT edit with instructions" },
      { "<leader>af", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "ChatGPT fix bugs", mode = modes },
      { "<leader>ag", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "ChatGPT grammar correction", mode = modes },
      { "<leader>ai", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "ChatGPT roxygen edit", mode = modes },
      { "<leader>ak", "<cmd>ChatGPTRun keywords<CR>", desc = "ChatGPT keywords", mode = modes },
      { "<leader>al", "<cmd>ChatGPTRun translate<CR>", desc = "ChatGPT translate", mode = modes },
      { "<leader>ao", "<cmd>ChatGPTRun optimize_code<CR>", desc = "ChatGPT optimize code", mode = modes },
      { "<leader>ar", "<cmd>ChatGPTRun<cr>", desc = "ChatGPT run actions" },
      { "<leader>at", "<cmd>ChatGPTRun add_tests<CR>", desc = "ChatGPT add tests", mode = modes },
      { "<leader>as", "<cmd>ChatGPTRun summarize<CR>", desc = "ChatGPT summarize", mode = modes },
      { "<leader>ax", "<cmd>ChatGPTRun explain_code<CR>", desc = "ChatGPT explain code", mode = modes },
      {
        "<leader>ay",
        "<cmd>ChatGPTRun code_readability_analysis<CR>",
        desc = "ChatGPT code readability analysis",
        mode = modes,
      },
    },
    opts = {},
  },
}