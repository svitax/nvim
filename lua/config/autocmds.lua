-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
-- local function augroup(name)
--   return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
-- end

-- close some filetypes with q
augroup("close_with_q", { clear = true })
autocmd("FileType", {
  group = "close_with_q",
  pattern = { "noice", "toggleterm", "neotest-output", "neotest-summary", "git", "dap-float" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- close some filetypes with <Esc>
augroup("close_with_esc", { clear = true })
autocmd("FileType", {
  group = "close_with_esc",
  pattern = { "OverseerForm" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "<Esc>", "<cmd>close!<cr>", { buffer = event.buf, silent = true })
  end,
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
