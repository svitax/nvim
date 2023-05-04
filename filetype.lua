-- Custom filetype detection logic with the new Lua filetype plugin
vim.filetype.add({
  extension = { png = "image", jpg = "image", jpeg = "image", gif = "image", tf = "terraform", qmd = "markdown" },
  filename = { [".eslintrc"] = "json", [".babelrc"] = "json" },
  pattern = { [".*config/git/config"] = "gitconfig", [".env.*"] = "sh" },
})
