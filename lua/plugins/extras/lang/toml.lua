return {
  -- add toml to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "toml" })
      end
    end,
  },
  { "neovim/nvim-lspconfig", opts = { servers = { taplo = {} } } },
}
