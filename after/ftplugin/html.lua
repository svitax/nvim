vim.keymap.set(
  { "n" },
  "<A-l>",
  "<cmd>lua require('jump-tag').jumpParent()<cr>",
  { desc = "Jump to parent node", buffer = true }
)
vim.keymap.set(
  { "n" },
  "<A-;>",
  "<cmd>lua require('jump-tag').jumpChild()<cr>",
  { desc = "Jump to child node", buffer = true }
)
vim.keymap.set(
  { "n" },
  "<A-j>",
  "<cmd>lua require('jump-tag').jumpNextSibling()<cr>",
  { desc = "Jump to next node", buffer = true }
)
vim.keymap.set(
  { "n" },
  "<A-k>",
  "<cmd>lua require('jump-tag').jumpPrevSibling()<cr>",
  { desc = "Jump to prev node", buffer = true }
)
