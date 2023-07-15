return {
  {
    "Olical/conjure",
    event = "VeryLazy",
    -- ft = { "python", "hy" },
    -- keys = { { "<localleader>" } },
    init = function()
      vim.api.nvim_create_autocmd("BufNewFile", {
        group = vim.api.nvim_create_augroup("conjure_log_disable_lsp", { clear = true }),
        pattern = { "conjure-log-*" },
        callback = function(event)
          vim.diagnostic.disable(event.buf)
        end,
        desc = "Conjure Log disable LSP diagnostics",
      })
      vim.g["conjure#extract#tree_sitter#enabled"] = true
      -- vim.g["conjure#mapping#prefix"] = "<localleader>"
      -- vim.cmd([[let g:conjure#mapping#prefix="h"]])
      -- vim.g.maplocalleader = "h"
      -- vim.g["conjure#mapping#prefix"] = " m"
      -- vim.g["conjure#client#python#stdio#mapping#start"] = "ca"
    end,
  },
  -- {
  --   "folke/which-key.nvim",
  --   -- optional = true,
  --   opts = {
  --     defaults = {
  --       ["<leader>m"] = { name = "+localleader" },
  --       -- ["<localleader>e"] = { name = "+evaluate" },
  --       -- ["<localleader>l"] = { name = "+logs" },
  --       -- ["<localleader>g"] = { name = "+goto" },
  --       -- ["<localleader>r"] = { name = "+reset" },
  --     },
  --   },
  -- },
  -- {
  --   "dccsillag/magma-nvim",
  --   build = ":UpdateRemotePlugins",
  --   opts = { magma_image_provider = "kitty" },
  --   keys = {
  --     { "<leader>ms", "<cmd>MagmaInit<cr>", desc = "Start Magma (evaluate)" },
  --     { "<leader>me", "<cmd>MagmaEvaluateLine<cr>", desc = "Evaluate line", mode = { "n" } },
  --     { "<leader>me", "<cmd>MagmaEvaluateVisual<cr>", desc = "Evaluate visual", mode = { "v" } },
  --   },
  -- },
}
