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

-- check if we need to reload the file when it changes
augroup("checktime", { clear = true })
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = "checktime",
  command = "checktime",
})

-- Go to last loc when opening a buffer
augroup("last_loc", {})
autocmd("BufReadPost", {
  group = "last_loc",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Automatically set read-only for files being edited elsewhere
augroup("open_swap", { clear = true })
autocmd("SwapExists", {
  group = "open_swap",
  nested = true,
  callback = function()
    vim.v.swapchoice = "o"
  end,
})

-- Create directories if needed when saving a file (except for URIs "://")
augroup("auto_create_dir", { clear = true })
autocmd("BufWritePre", {
  group = "auto_create_dir",
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
