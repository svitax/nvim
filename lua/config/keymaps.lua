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

local mode_sign = {
  insert = "i",
  normal = "n",
  terminal = "t",
  visual = "v",
  visual_block = "x",
  command = "c",
  operator_pending = "o",
  select = "s",
  replace = "r",
}

local function load_keymaps(mappings)
  for mode, mapping in pairs(mappings) do
    for key, value in pairs(mapping) do
      local options = {}

      if type(value) == "table" then
        options = value[2]
        value = value[1]
      end

      options = vim.tbl_extend("force", { silent = true }, options)
      vim.keymap.set(mode_sign[mode], key, value, options)
    end
  end
end

local mappings = {
  insert = {
    -- readline style bindings
    ["<c-a>"] = { "<esc>_i", { desc = "First non-whitespace character" } },
    ["<c-e>"] = { "<esc>$i", { desc = "End of line" } },

    -- select all
    ["<A-a>"] = { "<esc>ggVG$", { desc = "Select all" } },

    -- TODO: check if default in lazyvim
    -- Undo break points (for a finer-grained undo command)
    [","] = { ",<c-g>u", { desc = "" } },
    ["."] = { ".<c-g>u", { desc = "" } },
    ["!"] = { "!<c-g>u", { desc = "" } },
    ["?"] = { "?<c-g>u", { desc = "" } },
    ["<space>"] = { "<space><c-g>u", { desc = "" } },
    -- ["<cr>"] = { "<cr><c-g>u", { desc = "" } }, -- BUG: this breaks my indenting with <cr>
  },
  normal = {
    -- ["m"] = {}, -- TODO:
    -- ["M"] = {}, -- TODO:
    -- ["X"] = {}, -- TODO:
    -- ["Z"] = {}, -- TODO:

    -- ["<leader>a"] = {},
    -- ["<leader>b"] = {},
    -- ["<leader>c"] = {},
    -- ["<leader>d"] = {},
    -- ["<leader>e"] = {},
    -- ["<leader>f"] = {},
    -- ["<leader>g"] = {},
    -- ["<leader>h"] = {},
    -- ["<leader>i"] = {},
    -- ["<leader>j"] = {},
    -- ["<leader>k"] = {},
    -- ["<leader>l"] = {},
    -- ["<leader>m"] = {},
    -- ["<leader>n"] = {},
    -- ["<leader>o"] = {},
    -- ["<leader>p"] = {},
    -- ["<leader>q"] = {},
    -- ["<leader>r"] = {},
    -- ["<leader>s"] = {},
    -- ["<leader>t"] = {},
    -- ["<leader>u"] = {},
    -- ["<leader>v"] = {},
    -- ["<leader>w"] = {},
    -- ["<leader>x"] = {},
    -- ["<leader>y"] = {},
    -- ["<leader>z"] = {},

    -- ["<c-a>"] = {},
    -- ["<c-b>"] = {},
    -- ["<c-c>"] = {},
    -- ["<c-d>"] = {},
    -- ["<c-e>"] = {},
    -- ["<c-f>"] = {},
    -- ["<c-g>"] = {},
    -- ["<c-h>"] = {},
    -- ["<c-i>"] = {},
    -- ["<c-j>"] = {},
    -- ["<c-k>"] = {},
    -- ["<c-l>"] = {},
    -- ["<c-m>"] = {},
    -- ["<c-n>"] = {},
    -- ["<c-o>"] = {},
    -- ["<c-p>"] = {},
    -- ["<c-q>"] = {},
    -- ["<c-r>"] = {},
    -- ["<c-s>"] = {},
    -- ["<c-t>"] = {},
    -- ["<c-u>"] = {},
    -- ["<c-v>"] = {},
    -- ["<c-w>"] = {},
    -- ["<c-x>"] = {},
    -- ["<c-y>"] = {},
    -- ["<c-z>"] = {},

    -- ergonomic mappings for start/end of line (my terminal has Cmd+Left mapped to Shift+Left and Cmd+Right mapped to Shift+Right)
    ["H"] = { "_", { desc = "First non-whitespace character" } },
    ["L"] = { "$", { desc = "End of line" } },
    ["<S-Left>"] = { "_", { desc = "First non-whitespace character" } },
    ["<S-Right>"] = { "$", { desc = "End of line" } },

    -- stop highlighting from search
    ["<esc>"] = { "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" } },

    -- select all
    ["<A-a>"] = { "ggVG$", { desc = "Select all" } },

    -- cycle buffers
    ["<A-l>"] = { "<cmd>bnext<cr>", { desc = "Next buffer" } },
    ["<A-h>"] = { "<cmd>bprevious<cr>", { desc = "Previous buffer" } },

    -- ergonomic command mode ':'
    [";"] = { ":", { silent = false, nowait = true } },
    [":"] = { ";", { silent = false, nowait = true } },

    -- use , key for matching parens
    [","] = { "%", { remap = true, desc = "jump to paren (%)" } },

    -- TODO: prevent <tab> and <c-i> collision by remapping <c-i> to <F13> on OS level
    -- and <c-i> to <F13> in terminal/neovim
    -- toggle folds
    -- ["<tab>"] = { "za", { desc = "Toggle fold" } },

    -- jump list next ('<F13>' is what <c-i> sends, thanks to OS remap. addresses collision with tab)
    ["<F13>"] = "<c-i>",

    -- quit all
    ["<leader>qq"] = { "<cmd>qa<cr>", { desc = "Quit all" } },

    -- lua/config/autocmds.lua
    ["<leader>fM"] = { "<cmd>Rename<cr>", { desc = "Rename this file" } },
    ["<leader>fD"] = { "<cmd>Delete<cr>", { desc = "Delete this file" } },

    -- Yank buffer's relative path to clipboard
    ["<leader>yr"] = {
      function()
        local path = vim.fn.expand("%:~:.")
        vim.fn.setreg("+", path)
        vim.notify(path, vim.log.levels.info, { title = "Yanked relative path" })
      end,
      { silent = true, desc = "Yank relative path" },
    },

    -- Yank buffer's absolute path to clipboard
    ["<leader>ya"] = {
      function()
        local path = vim.fn.expand("%:p")
        vim.fn.setreg("+", path)
        vim.notify(path, vim.log.levels.info, { title = "Yanked absolute path" })
      end,
      { silent = true, desc = "Yank absolute path" },
    },

    -- i to indent properly on empty lines
    ["i"] = {
      function()
        if #vim.fn.getline(".") == 0 then
          return [["_cc]]
        else
          return "i"
        end
      end,
      { expr = true },
    },

    -- smart deletion, dd
    -- solves the issue where you want to delete an empty line, but dd will override your last yank
    -- will check you are deleting an empty line, if so - use the black hole register
    ["dd"] = {
      function()
        if vim.api.nvim_get_current_line():match("^%s*$") then
          return '"_dd'
        else
          return "dd"
        end
      end,
      { noremap = true, expr = true },
    },

    -- toggle options
    ["<leader>ul"] = { require("utils").toggle_lsp_in_modeline, { desc = "Toggle show lsp in modeline" } },
    ["<leader>uf"] = { require("lazyvim.plugins.lsp.format").toggle, { desc = "Toggle format on save" } },
    ["<leader>us"] = {
      function()
        lv_utils.toggle("spell")
      end,
      { desc = "Toggle spelling", expr = true },
    },
    ["<leader>uw"] = {
      function()
        lv_utils.toggle("wrap")
      end,
      { desc = "Toggle word wrap", expr = true },
    },
    ["<leader>uL"] = { lv_utils.toggle_number, { desc = "Toggle line numbers" } },
    ["<leader>ud"] = { lv_utils.toggle_diagnostics, { desc = "Toggle diagnostics" } },
    ["<leader>uc"] = {
      function()
        local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
        lv_utils.toggle("conceallevel", false, { 0, conceallevel })
      end,
      { desc = "Toggle conceal", expr = true },
    },
    ["<leader>uh"] = {
      function()
        vim.lsp.inlay_hint(0, nil)
      end,
      { desc = "Toggle inlay hints", expr = true },
    },
  },
  visual = {
    -- ergonomic mappings for start/end of line (my terminal has Cmd+Left mapped to Shift+Left and Cmd+Right mapped to Shift+Right)
    ["H"] = { "_", { desc = "First non-whitespace character" } },
    ["L"] = { "$", { desc = "End of line" } },
    ["<S-Left>"] = { "_", { desc = "First non-whitespace character" } },
    ["<S-Right>"] = { "$", { desc = "End of line" } },

    -- better indenting
    ["<"] = "<gv",
    [">"] = ">gv",
  },
  command = {
    -- Basic autocomplete for command mode
    ["("] = { "()<left>", { silent = false } },
    ["["] = { "[]<left>", { silent = false } },
    ["{"] = { "{}<left>", { silent = false } },
    ['"'] = { [[""<left>]], { silent = false } },
    ["'"] = { [[''<left>]], { silent = false } },

    -- Feeds absolute filepath of current buffer into cmd
    ["%%"] = {
      function()
        vim.api.nvim_feedkeys(vim.fn.expand("%:p:h") .. "/", "c", false)
      end,
      { expr = true },
    },
  },
  visual_block = {
    -- Quick substitute within selected area
    ["<leader>sg"] = { ":s///gc<Left><Left><Left><Left>", { desc = "Substitute within selection" } },
  },
  terminal = {
    -- readline style bindings
    ["<c-a>"] = { "<esc>_i", { desc = "First non-whitespace character" } },
    ["<c-e>"] = { "<esc>$i", { desc = "End of line" } },
  },
  operator_pending = {
    -- ergonomic mappings for start/end of line
    ["H"] = { "_", { desc = "First non-whitespace character" } },
    ["L"] = { "$", { desc = "End of line" } },
  },
}

-- I use jkl; instead of hjkl
-- map({ "n", "x" }, ";", "l", { desc = "Right" })
-- map({ "n", "x" }, "l", "h", { desc = "Left" })

-- since I don't use h to move cursor, might as well use it to enter command mode
-- map({ "n", "v" }, "h", ":", { desc = "Command" })

-- <C-Bs> maps to <C-h> in terminals, but I like to have <C-bs> delete the previous word.
-- map({ "i", "c" }, "<C-h>", "<C-w>", { desc = "Delete previous word (<C-bs>)" })
-- map({ "i", "c" }, "<C-bs>", "<C-w>", { desc = "Delete previous word (<C-bs>)" })
-- <A-bs> is mapped to delete previous word on my keyboard (macos), make that consistent inside nvim
-- map({ "i" }, "<A-bs>", "<C-w>", { desc = "Delete previous word" })

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

-- vv selects the whole line
-- map({ "n" }, "vv", "V", { desc = "Select whole line" })
-- V select until the end of the line
-- map({ "n" }, "V", "v$", { desc = "Select to end of line" })

-- -- replaces netrw's gx
-- map("n", "gx", function()
--   require("various-textobjs").url() -- select URL
--   -- this works since the plugin switched to visual mode
--   -- if the textobj has been found
--   local foundURL = vim.fn.mode():find("v")
--   -- if not found in proximity, search whole buffer via urlview.nvim instead
--   if not foundURL then
--     vim.cmd.UrlView("buffer")
--     return
--   end
--   -- retrieve URL with the z-register as intermediary
--   vim.cmd.normal({ '"zy', bang = true })
--   local url = vim.fn.getreg("z")
--   -- open with the OS-specific shell command
--   local opener
--   if vim.fn.has("macunix") == 1 then
--     opener = "open"
--   elseif vim.fn.has("linux") == 1 then
--     opener = "xdg-open"
--   elseif vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
--     opener = "start"
--   end
--   local openCommand = string.format("%s '%s' >/dev/null 2>&1", opener, url)
--   os.execute(openCommand)
-- end, { desc = "Smart URL Opener" })

-- { "<leader>p&", desc = "Async cmd in project root" }, -- overseer
-- { "<leader>p.", desc = "Browse project" },
-- { "<leader>p>", desc = "Browse other project" },
-- { "<leader>pf", desc = "Find file in project" },
-- { "<leader>pt", desc = "List project todos" }, -- trouble
-- { "<leader>px", desc = "Pop up scratch buffer" },
-- { "<leader>pX", desc = "Switch to scratch buffer" },

load_keymaps(mappings)

-- vim.cmd "colorscheme terafox"
