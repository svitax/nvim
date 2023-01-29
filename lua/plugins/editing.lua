return {
  -- <A-n> and <A-p> to cycle through yank history (like Emacs 'kill-ring.')
  {
    "gbprod/yanky.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function(_, opts)
      require("yanky").setup(opts)
      require("telescope").load_extension("yank_history")
    end,
    opts = { highlight = { timer = 150 } },
    keys = {
      { "p", "<Plug>(YankyPutAfter)", desc = "Put after" },
      { "P", "<Plug>(YankyPutBefore)", desc = "Put before" },
      -- { "gp", "<Plug>(YankyGPutAfter)", desc = "gput after" },
      -- { "gP", "<Plug>(YankyGPutBefore)", desc = "gput before" },
      { "<A-n>", "<Plug>(YankyCycleForward)", desc = "Cycle kill ring forward" },
      { "<A-p>", "<Plug>(YankyCycleBackward)", desc = "Cycle kill ring backward" },
      { "<leader>sy", "<cmd>Telescope yank_history<cr>", desc = "Yank history" },
    },
  },
  {
    "axelvc/template-string.nvim",
    ft = { "javascript", "typescript", "python", "javascriptreact", "typescriptreact" },
    config = true,
  },
  {
    "Wansmer/binary-swap.nvim",
    dependencies = { "nvim-treesitter" },
    keys = {
      {
        "<A-.>",
        "<cmd>lua require('binary-swap').swap_operands()<cr>",
        mode = { "n", "i" },
        desc = "Swap operands",
      },
      {
        "<A-,>",
        "<cmd>lua require('binary-swap').swap_operands_with_operator()<cr>",
        mode = { "n", "i" },
        desc = "Swap operands and operator",
      },
    },
  },
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter" },
    opts = { use_default_keymaps = false },
    event = "BufReadPost",
    config = function(_, opts)
      require("treesj").setup(opts)
      local langs = require("treesj.langs")["presets"]
      vim.api.nvim_create_autocmd({ "FileType" }, {
        group = vim.api.nvim_create_augroup("TreesjFallback", { clear = true }),
        pattern = "*",
        -- TODO: if TSJToggle fails, fallback to regular J
        callback = function()
          if langs[vim.bo.filetype] or vim.bo.filetype == "typescriptreact" or vim.bo.filetype == "javascriptreact" then
            vim.keymap.set("n", "J", "<cmd>TSJToggle<cr>", { buffer = true, desc = "Join toggle" })
          end
        end,
      })
    end,
  },
}
