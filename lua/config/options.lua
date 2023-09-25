-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = " "
vim.g.maplocalleader = " m"

vim.o.fillchars = [[diff:╱]]
vim.o.conceallevel = 1
vim.o.timeoutlen = 500
vim.opt.relativenumber = false
vim.opt.listchars:append("lead:⋅")
vim.opt.listchars:append("leadmultispace:⋅")
vim.opt.listchars:append("trail:⋅")
vim.opt.listchars:append("eol:󰌑")
vim.opt.listchars:append("tab:» ")
vim.opt.colorcolumn = "120"
vim.opt.cmdheight = 1

-- backup
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.local/state/nvim/undo"
vim.opt.undofile = true

-- config folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.fillchars:append("fold: ")
vim.opt.fillchars:append("foldopen:")
vim.opt.fillchars:append("foldclose:")
vim.opt.fillchars:append("foldsep: ")
-- fold settings required for UFO
vim.opt.foldcolumn = "1"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
