-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
-- local function augroup(name)
--   return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
-- end

-- close some filetypes with <q>
augroup("close_with_q", { clear = true })
autocmd("FileType", {
  group = "close_with_q",
  pattern = {
    "noice",
    "toggleterm",
    "neotest-output",
    "neotest-summary",
    "fugitive",
    "floggraph",
    "git",
    "gitcommit",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
augroup("quit_with_q", { clear = true })
autocmd("FileType", {
  group = "quit_with_q",
  pattern = { "gitcommit" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>quit<cr>", { buffer = event.buf, silent = true })
  end,
})

augroup("zsh_as_bash", {})
autocmd("BufWinEnter", {
  group = "zsh_as_bash",
  pattern = { "*.sh", "*.zsh", ".zshrc" },
  command = "silent! set filetype=sh",
})

-- wrap and check for spell in text filetypes
-- vim.api.nvim_create_autocmd("FileType", {
--   group = vim.api.nvim_create_augroup("wrap_spell", { clear = true }),
--   pattern = { "gitcommit", "markdown" },
--   callback = function()
--     vim.opt_local.wrap = true
--     vim.opt_local.spell = false
--   end,
-- })
