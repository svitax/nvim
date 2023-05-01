return {
  {
    "lambdalisue/suda.vim",
    event = "BufRead",
    cmd = { "SudaRead", "SudaWrite" },
    keys = {
      { "<leader>fs", ":SudaWrite ", desc = "Sudo write file" },
      { "<leader>fS", ":SudaRead ", desc = "Sudo read file" },
    },
  },
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
}
