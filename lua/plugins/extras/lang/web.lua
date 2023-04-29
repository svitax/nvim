-- stylua: ignore
if true then return {} end

return {
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    keys = { { "<leader>mh", "<Plug>RestNvim", desc = "Execute HTTP request" } },
    opts = { skip_ssl_verification = true },
  },
}
-- return {
--   {
--     "hrsh7th/nvim-cmp",
--     dependencies = {
--       { "dcampos/cmp-emmet-vim", dependencies = "mattn/emmet-vim" },
--       { "David-Kunz/cmp-npm", opts = { only_semantic_versions = true } },
--     },
--     opts = function(_, opts)
--       local cmp = require("cmp")
--
--       opts.cmp_source_names["emmet_vim"] = "(emmet)"
--       opts.cmp_source_names["npm"] = "(npm)"
--
--       opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
--         { name = "emmet_vim" },
--         { name = "npm", keyword_length = 4, priority = 10 },
--       }, 1, #opts.sources))
--     end,
--   },
--   {
--     "nvim-treesitter/nvim-treesitter",
--     opts = function(_, opts)
--       vim.list_extend(opts.ensure_installed, { ensure_installed = { "css", "html" } }, 1, #opts.ensure_installed)
--     end,
--   },
--   {
--     "williamboman/mason.nvim",
--     opts = function(_, opts)
--       vim.list_extend(opts.ensure_installed, {
--         "prettierd",
--         "eslint-lsp",
--         "css-lsp",
--         -- "fixjson"
--         "jsonlint",
--       }, 0, #opts.ensure_installed)
--     end,
--   },
--   {
--     "jose-elias-alvarez/null-ls.nvim",
--     opts = function(_, opts)
--       local nls = require("null-ls")
--       table.insert(opts.sources, nls.builtins.formatting.prettierd)
--       table.insert(opts.sources, nls.builtins.diagnostics.jsonlint.with({ extra_filetypes = { "jsonc" } }))
--     end,
--   },
-- }
