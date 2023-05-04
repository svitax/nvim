-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.fillchars = [[diff:╱]]
vim.o.conceallevel = 1
vim.o.timeoutlen = 500
vim.opt.listchars:append("lead:⋅")
vim.opt.listchars:append("leadmultispace:⋅")
vim.opt.listchars:append("trail:⋅")
vim.opt.listchars:append("eol:󰌑")
vim.opt.colorcolumn = "120"
