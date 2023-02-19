-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  --- @cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- map("n", "gl", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
-- I use jkl; instead of hjkl
map({ "n", "x" }, ";", "l", { desc = "Right" })
map({ "n", "x" }, "l", "h", { desc = "Left" })
-- since I don't use h to move cursor, might as well use it to enter command mode
map({ "n", "v" }, "h", ":", { desc = "Command" })
-- ergonmic mappings for end of line and beginning of line (my terminal has Cmd+Left mapped to Shift+Left and Cmd+Right mapped to Shift+Right)
map({ "n", "v" }, "<S-Left>", "_", { desc = "First non-whitespace character" })
map({ "n", "v" }, "<S-Right>", "$", { desc = "End of line" })
-- <C-Bs> maps to <C-h> in terminals, but I like to have <C-bs> delete the previous word.
map({ "i", "c" }, "<C-h>", "<C-w>", { desc = "Delete previous word (<C-bs>)" })
map({ "i", "c" }, "<C-bs>", "<C-w>", { desc = "Delete previous word (<C-bs>)" })
-- <A-bs> is mapped to delete previous word on my keyboard (macos), make that consistent inside nvim
map({ "i" }, "<A-bs>", "<C-w>", { desc = "Delete previous word" })
-- select all
map({ "i" }, "<A-a>", "<esc>ggVG$", { desc = "Select all" })
map({ "n", "v" }, "<A-a>", "ggVG$", { desc = "Select all" })
-- Move lines with <C-a-j/k> because I'm already using <A-j/k> and <S-A-j/k> for treeclimber
map("n", "<C-A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<C-A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<C-A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<C-A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<C-A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<C-A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- delete some LazyVim mappings I don't use
vim.keymap.del("n", "<leader>w-")
vim.keymap.del("n", "<leader>w|")
vim.keymap.del("n", "<leader>-")
vim.keymap.del("n", "<leader>|")
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")
vim.keymap.del("n", "<leader><tab>l")
vim.keymap.del("n", "<leader><tab>f")
vim.keymap.del("n", "<leader>`")
vim.keymap.del("n", "<leader>gG")

-- { "<leader>p&", desc = "Async cmd in project root" }, -- overseer
-- { "<leader>p.", desc = "Browse project" },
-- { "<leader>p>", desc = "Browse other project" },
-- { "<leader>pf", desc = "Find file in project" },
-- { "<leader>pt", desc = "List project todos" }, -- trouble
-- { "<leader>px", desc = "Pop up scratch buffer" },
-- { "<leader>pX", desc = "Switch to scratch buffer" },
