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
  pattern = { "noice", "toggleterm", "neotest-output", "neotest-summary", "git", "dap-float" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
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

-- wrap and check for spell in text filetypes
-- vim.api.nvim_create_autocmd("FileType", {
--   group = vim.api.nvim_create_augroup("wrap_spell", { clear = true }),
--   pattern = { "gitcommit", "markdown" },
--   callback = function()
--     vim.opt_local.wrap = true
--     vim.opt_local.spell = false
--   end,
-- })

augroup("checktime", { clear = true })
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  desc = "Reload file if it changes on disk",
  group = "checktime",
  command = "checktime",
})

augroup("last_loc", {})
autocmd("BufReadPost", {
  desc = "Go to last location when opening a buffer",
  group = "last_loc",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

augroup("open_swap", { clear = true })
autocmd("SwapExists", {
  desc = "Automatically set read-only for files being edited elsewhere",
  group = "open_swap",
  nested = true,
  callback = function()
    vim.v.swapchoice = "o"
  end,
})

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
    if vim.loop.fs_stat(args.file).size > 1000 * 1024 then
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
      vim.api.nvim_command(event.buf .. "bwipeout")
    end
  end,
})
