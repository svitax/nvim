return {
  name = "rewriter all tests",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand("%:p")
    local test_file = "unit_" .. vim.fn.expand("%:p:t")
    return {}
  end,
  condition = {
    filetype = { "text" },
    dir = { "~/projects/hydra-fe-resources/" },
  },
}
