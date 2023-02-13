-- Add the key mappings only for Markdown files in a zk notebook.
if require("zk.util").notebook_root(vim.fn.expand("%:p")) ~= nil then
  -- Open the link under the caret.
  vim.keymap.set(
    "n",
    "<CR>",
    "<Cmd>lua vim.lsp.buf.definition()<CR>",
    { buffer = true, noremap = true, silent = false, desc = "Follow link" }
  )
  -- Create a new note after asking for its title.
  -- This overrides the global `<leader>nN` mapping to create the note in the same directory as the current buffer.
  -- vim.keymap.set(
  --   "n",
  --   "<leader>nN",
  --   "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
  --   { buffer = true, silent = false, desc = "New note (cwd)" }
  -- )
  -- Create a new note in the same directory as the current buffer, using the current selection for title.
  -- vim.keymap.set(
  --   "v",
  --   "<leader>nT",
  --   ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>",
  --   { buffer = true, silent = false, desc = "New note (cwd) with selection as title" }
  -- )
  -- -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
  -- vim.keymap.set(
  --   "v",
  --   "<leader>nC",
  --   ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
  --   { buffer = true, silent = false, desc = "New note (cwd) with selection as content" }
  -- )
else
  vim.notify("zk-nvim not found")
end

local ok, _ = pcall(require, "toggle-checkbox")
if ok then
  vim.keymap.set(
    "n",
    "<A-cr>",
    "<cmd>lua require('toggle-checkbox').toggle()<cr>",
    { desc = "Toggle checkbox", buffer = true, silent = true }
  )
else
  vim.notify("toggle-checkbox not loaded")
end
