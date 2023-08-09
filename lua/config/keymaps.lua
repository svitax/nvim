-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local lv_utils = require("lazyvim.util")

-- delete some LazyVim mappings I don't use
-- vim.keymap.del("n", "<leader>w-")
-- vim.keymap.del("n", "<leader>w|")
-- vim.keymap.del("n", "<leader>-")
-- vim.keymap.del("n", "<leader>|")
-- vim.keymap.del("n", "<leader>ft")
-- vim.keymap.del("n", "<leader>fT")
-- vim.keymap.del("n", "<leader><tab>l")
-- vim.keymap.del("n", "<leader><tab>f")
-- vim.keymap.del("n", "<leader>`")
-- vim.keymap.del("n", "<leader>bb")
-- vim.keymap.del("n", "<leader>gG")
-- -- vim.keymap.del("n", "<leader>qq")
-- vim.keymap.del("n", "<leader>bd")
-- vim.keymap.del("n", "<leader>bD")
-- vim.keymap.del("n", "<leader>xl")
-- vim.keymap.del("n", "<leader>xq")

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
-- map({ "i", "c" }, "<C-h>", "<C-w>", { desc = "Delete previous word (<C-bs>)" })
-- map({ "i", "c" }, "<C-bs>", "<C-w>", { desc = "Delete previous word (<C-bs>)" })
-- <A-bs> is mapped to delete previous word on my keyboard (macos), make that consistent inside nvim
-- map({ "i" }, "<A-bs>", "<C-w>", { desc = "Delete previous word" })
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
-- TODO: check if default in lazyvim
-- keep cursor centered when using n(next) and N(previous)
-- map({ "n", "v" }, "n", "nzzzv", { description = "Go to next match (centered)" })
-- map({ "n", "v" }, "N", "Nzzzv", { description = "Go to previous match (centered)" })
-- TODO: check if default in lazyvim
-- Undo break points (for a finer-grained undo command)
-- map({ "i" }, ",", ",<c-g>u", { description = "" })
-- map({ "i" }, ".", ".<c-g>u", { description = "" })
-- map({ "i" }, "!", "!<c-g>u", { description = "" })
-- map({ "i" }, "?", "?<c-g>u", { description = "" })
-- map({ "i" }, "<cr>", "<cr>c-g>u", { description = "" })
-- map({ "i" }, "<space>", "<space><c-g>u", { description = "" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Use , key for matching parens
map({ "n", "x" }, ",", "%", { remap = true, desc = "jump to paren" })

-- Quick substitute within selected area
map("x", "<leader>sg", ":s///gc<Left><Left><Left><Left>", { desc = "Substitute within selection" })

-- i to indent properly on empty lines
map({ "n", "v", "x" }, "i", function()
  if #vim.fn.getline(".") == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, { expr = true })

-- Yank buffer's relative path to clipboard
map("n", "<leader>yr", function()
  local path = vim.fn.expand("%:~:.")
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.info, { title = "Yanked relative path" })
end, { silent = true, desc = "Yank relative path" })

-- Yank buffer's absolute path to clipboard
map("n", "<leader>ya", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.info, { title = "Yanked absolute path" })
end, { silent = true, desc = "Yank absolute path" })

-- replaces netrw's gx
map("n", "gx", function()
  require("various-textobjs").url() -- select URL
  -- this works since the plugin switched to visual mode
  -- if the textobj has been found
  local foundURL = vim.fn.mode():find("v")
  -- if not found in proximity, search whole buffer via urlview.nvim instead
  if not foundURL then
    vim.cmd.UrlView("buffer")
    return
  end
  -- retrieve URL with the z-register as intermediary
  vim.cmd.normal({ '"zy', bang = true })
  local url = vim.fn.getreg("z")
  -- open with the OS-specific shell command
  local opener
  if vim.fn.has("macunix") == 1 then
    opener = "open"
  elseif vim.fn.has("linux") == 1 then
    opener = "xdg-open"
  elseif vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
    opener = "start"
  end
  local openCommand = string.format("%s '%s' >/dev/null 2>&1", opener, url)
  os.execute(openCommand)
end, { desc = "Smart URL Opener" })

-- smart deletion, dd
-- solves the issue where you want to delete an empty line, but dd will override your last yank
-- will check you are deleting an empty line, if so - use the black hole register
map("n", "dd", function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end, { noremap = true, expr = true })

-- lua/config/autocmds.lua
map("n", "<leader>fM", "<cmd>Rename<cr>", { desc = "Rename this file" })
map("n", "<leader>fD", "<cmd>Delete<cr>", { desc = "Delete this file" })

-- { "<leader>p&", desc = "Async cmd in project root" }, -- overseer
-- { "<leader>p.", desc = "Browse project" },
-- { "<leader>p>", desc = "Browse other project" },
-- { "<leader>pf", desc = "Find file in project" },
-- { "<leader>pt", desc = "List project todos" }, -- trouble
-- { "<leader>px", desc = "Pop up scratch buffer" },
-- { "<leader>pX", desc = "Switch to scratch buffer" },

-- toggle options
map("n", "<leader>uf", require("lazyvim.plugins.lsp.format").toggle, { desc = "Toggle format on Save" })
map("n", "<leader>us", function()
  lv_utils.toggle("spell")
end, { desc = "Toggle Spelling" })
map("n", "<leader>uw", function()
  lv_utils.toggle("wrap")
end, { desc = "Toggle Word Wrap" })
map("n", "<leader>ul", function()
  lv_utils.toggle_number()
end, { desc = "Toggle Line Numbers" })
map("n", "<leader>ud", lv_utils.toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function()
  lv_utils.toggle("conceallevel", false, { 0, conceallevel })
end, { desc = "Toggle Conceal" })
if vim.lsp.inlay_hint then
  map("n", "<leader>uh", function()
    vim.lsp.inlay_hint(0, nil)
  end, { desc = "Toggle Inlay Hints" })
end

-- vim.cmd "colorscheme terafox"
