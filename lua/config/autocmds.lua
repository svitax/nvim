-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local command = vim.api.nvim_create_user_command
-- local function augroup(name)
--   return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
-- end

command("Delete", function()
  local fp = vim.api.nvim_buf_get_name(0)
  local ok, err = vim.loop.fs_unlink(fp)
  if not ok then
    vim.notify(table.concat({ fp, err }, "\n"), vim.log.levels.ERROR, { title = ":Delete failed" })
    vim.cmd.edit()
  else
    require("utils").close_buffer()
    vim.notify(fp, vim.log.levels.INFO, { title = ":Delete succeeded" })
  end
end, { desc = "Delete current file" })

command("Rename", function()
  local prev = vim.fn.expand("%")
  vim.ui.input({
    prompt = "New file name: ",
    default = prev,
    completion = "file",
  }, function(next)
    if not next or next == "" or next == prev then
      return
    end
    vim.cmd.saveas(next)
    local ok, err = vim.loop.fs_unlink(prev)
    if not ok then
      vim.notify(
        table.concat({ prev, err }, "\n"),
        vim.log.levels.ERROR,
        { title = ":Rename failed to delete original" }
      )
    end
    vim.cmd.redraw({ bang = true })
  end)
end, { desc = "Rename current file" })

augroup("close_with_q", { clear = true })
autocmd("FileType", {
  desc = "Close certain filetypes with 'q'",
  group = "close_with_q",
  pattern = {
    "noice",
    "toggleterm",
    "neotest-output",
    "neotest-summary",
    "git",
    "dap-float",
    "oil",
    "httpResult",
    "",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- NOTE: when I close a jqx filetype, it puts me in my incline buffer. need to quit twice.
augroup("jqx_close_with_q", { clear = true })
autocmd("FileType", {
  desc = "Close jqx filetypes with 'q'",
  group = "jqx_close_with_q",
  pattern = { "jqx" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr><cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

augroup("close_with_esc", { clear = true })
autocmd("FileType", {
  desc = "Close certain filetypes with '<esc>'",
  group = "close_with_esc",
  pattern = { "OverseerForm" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "<Esc>", "<cmd>close!<cr>", { buffer = event.buf, silent = true })
  end,
})

-- term keymaps
-- augroup("terminal_keymappings", { clear = true })
-- autocmd("TermOpen", {
--   desc = "Keymappings for the terminal filetype",
--   group = "terminal_keymappings",
--   callback = function(event)
--     vim.keymap.set("t", "<c-j>", [[<Cmd>wincmd j<CR>]], { buffer = true, desc = "Switch window down" })
--     vim.keymap.set("t", "<c-k>", [[<Cmd>wincmd k<CR>]], { buffer = true, desc = "Switch window up" })
--     vim.keymap.set("t", "<c-l>", [[<Cmd>wincmd h<CR>]], { buffer = true, desc = "Switch window left" })
--     vim.keymap.set("t", "<c-h>", [[<Cmd>wincmd l<CR>]], { buffer = true, desc = "Switch window right" })
--     vim.keymap.set("t", "<ESC>", [[<c-\><c-n>]], { buffer = true, desc = "Exit terminal mode" })
--     vim.keymap.set("t", "<C-h>", "<C-w>", { buffer = true, desc = "Delete previous word (<C-bs>)" })
--     vim.keymap.set("t", "<C-bs>", "<C-w>", { buffer = true, desc = "Delete previous word (<C-bs>)" })
--   end,
-- })

-- wrap and check for spell in text filetypes
-- vim.api.nvim_create_autocmd("FileType", {
--   group = vim.api.nvim_create_augroup("wrap_spell", { clear = true }),
--   pattern = { "gitcommit", "markdown" },
--   callback = function()
--     vim.opt_local.wrap = true
--     vim.opt_local.spell = false
--   end,
-- })

-- Already in LazyVim
-- augroup("checktime", { clear = true })
-- autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
--   desc = "Reload file if it changes on disk",
--   group = "checktime",
--   command = "checktime",
-- })

-- Already in LazyVim
-- augroup("last_loc", {})
-- autocmd("BufReadPost", {
--   desc = "Go to last location when opening a buffer",
--   group = "last_loc",
--   callback = function()
--     local mark = vim.api.nvim_buf_get_mark(0, '"')
--     local lcount = vim.api.nvim_buf_line_count(0)
--     if mark[1] > 0 and mark[1] <= lcount then
--       pcall(vim.api.nvim_win_set_cursor, 0, mark)
--     end
--   end,
-- })

-- augroup("open_swap", { clear = true })
-- autocmd("SwapExists", {
--   desc = [[Automatically set read-only for files being edited elsewhere.
--   Choose recover. If you want to delete the swap write and then call :e and choose delete this time.]],
--   group = "open_swap",
--   nested = true,
--   callback = function()
--     vim.v.swapchoice = "o"
--   end,
-- })

augroup("auto_create_dir", { clear = true })
autocmd("BufWritePre", {
  desc = "Create directories if needed when saving a file (except for URIs '://')",
  group = "auto_create_dir",
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

augroup("reading", { clear = true })
autocmd("BufReadPre", {
  desc = "Disable linting and syntax highlighting for large files",
  group = "reading",
  callback = function(args)
    -- See the treesitter highlight config too
    if vim.loop.fs_stat(args.file).size > 500 * 1024 then
      vim.cmd.syntax("manual")
    end
  end,
})
autocmd("BufReadPre", {
  pattern = "*.min.*",
  desc = "Disable linting and syntax highlighting for minified files",
  group = "reading",
  command = "syntax manual",
})

-- setting this in vim.opt.formatoptions or set formatoptions-=cro in config/options.lua doesn't work
augroup("format_options", { clear = true })
autocmd("FileType", {
  desc = "Disable auto commenting of new lines",
  command = "set formatoptions-=cro",
  group = "format_options",
})

-- requires "famiu/bufdelete.nvim" and "goolord/alpha.nvim"
augroup("alpha_on_empty", { clear = true })
autocmd("User", {
  desc = "Show Alpha dashboard when there is no buffer left",
  pattern = "BDeletePost*",
  group = "alpha_on_empty",
  callback = function(event)
    local fallback_name = vim.api.nvim_buf_get_name(event.buf)
    local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
    local fallback_on_empty = fallback_name == "" and fallback_ft == ""
    if fallback_on_empty then
      -- require("neo-tree").close_all()
      vim.api.nvim_command("Alpha")
      -- require("close_buffers").wipe({ type = event.buf }) -- close_buffers doesn't provide an event after delete like bufdelete does (BDeletePost)
      vim.api.nvim_command(event.buf .. "Bwipeout")
    end
  end,
})

augroup("open_pdf", {})
autocmd("BufReadPost", {
  desc = "Open PDFs using Neovim from your xdg assigned viewer.",
  pattern = "*.pdf",
  group = "open_pdf",
  callback = function(event)
    local filename = event.file
    vim.fn.jobstart({ "xdg-open", filename }, { detach = true })
    vim.api.nvim_command(event.buf .. "Bwipeout")
  end,
})

augroup("modicator", { clear = true })
autocmd("ModeChanged", {
  desc = "Change foreground color of CursorLineNr highlight based on current Vim mode",
  pattern = "*:[tcvV\x16]",
  group = "modicator",
  callback = function()
    local modes = require("shared").mode_colors
    vim.api.nvim_set_hl(0, "CursorLineNr", { foreground = modes[vim.api.nvim_get_mode().mode] or "#665c54" })
    -- vim.api.nvim_set_hl(0, "CursorLine", { bg = require("utils").blend(modes["v"], "#32302f", 0.15) })
  end,
})
autocmd("InsertEnter", {
  desc = "Change foreground color of CursorLineNr highlight based on current Vim mode",
  pattern = "*",
  group = "modicator",
  callback = function()
    local modes = require("shared").mode_colors
    vim.api.nvim_set_hl(0, "CursorLineNr", { foreground = modes["i"] })
    -- vim.api.nvim_set_hl(0, "CursorLine", { background = require("utils").blend(modes["i"], "#32302f", 0.10) })
  end,
})
---Reset highlights
autocmd("ModeChanged", {
  desc = "Change foreground color of CursorLineNr highlight based on current Vim mode",
  pattern = "[tcvV\x16]:n",
  group = "modicator",
  callback = function()
    vim.api.nvim_set_hl(0, "CursorLineNr", { foreground = "#665c54" })
  end,
})
autocmd({ "CmdlineLeave", "InsertLeave", "TextYankPost", "WinLeave" }, {
  desc = "Change foreground color of CursorLineNr highlight based on current Vim mode",
  pattern = "*",
  group = "modicator",
  callback = function()
    vim.api.nvim_set_hl(0, "CursorLineNr", { foreground = "#665c54" })
    -- vim.api.nvim_set_hl(0, "CursorLine", { background = "#32302f" })
  end,
})

-- Array of file names indicating root directory. Modify to your liking
local root_names = { ".git", "Makefile", "pyproject.toml" }
-- Cache to use for speed up (at cost of possibly outdated results)
local root_cache = {}
augroup("auto_root", {})
autocmd("BufEnter", {
  desc = "Auto change current directory (vim-rooter)",
  group = "auto_root",
  callback = function()
    -- Get directory path to start search from
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" then
      return
    end
    path = vim.fs.dirname(path)

    -- Try cache and resort to searching upward for root directory
    local root = root_cache[path]
    if root == nil then
      local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
      if root_file == nil then
        return
      end
      root = vim.fs.dirname(root_file)
      root_cache[path] = root
    end

    -- Set current directory and
    vim.fn.chdir(root)
    -- If new cwd has a pyproject.toml file, activate cached venv from venv-selector
    -- I'm auto activating venvs like this because the DirChanged event isn't firing when I auto root like this
    -- Downside is we're setting venv every time we navigate to a buffer in a python project, when really we only need to do it once
    -- if vim.fn.chdir(root) and (vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";") ~= "") then
    --   require("venv-selector").retrieve_from_cache()
    -- end
  end,
})

-- augroup("auto_open_telescope", {})
-- autocmd("VimEnter", {
--   desc = "Auto open Telescope on VimEnter if buffer is a directory",
--   group = "auto_open_telescope",
--   callback = function()
--     local bufferPath = vim.fn.expand("%:p")
--     local lv_utils = require("lazyvim.util")
--     local ts_builtin = require("telescope.builtin")
--
--     if vim.fn.isdirectory(bufferPath) ~= 0 then
--       vim.api.nvim_buf_delete(0, { force = true })
--       -- ts_builtin.find_files({ show_untracked = true })
--       lv_utils.telescope("git_files", { cwd = false, show_untracked = true })()
--     end
--   end,
-- })

-- augroup("delete_nonexist", { clear = true })
-- autocmd({ "FocusGained" }, {
--   desc = "Wipeout buffer if file deleted from disk",
--   group = "delete_nonexist",
--   callback = function()
--     -- Get the current buffer
--     local bufnr = vim.api.nvim_get_current_buf()
--     -- Get the file path of the buffer
--     local filepath = vim.api.nvim_buf_get_name(bufnr)
--     -- Check if the file exists
--     local stat = vim.loop.fs_stat(filepath)
--     if not (stat and stat.type == "file") then
--       -- require("utils").close_buffer()
--       vim.api.nvim_buf_delete(0, {})
--     end
--   end,
-- })
