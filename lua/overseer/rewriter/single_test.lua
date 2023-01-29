return {
  name = "rewriter single test",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand("%:p")
    local test_file = "unit_" .. vim.fn.expand("%:p:t")
    return {
      cmd = { "rewriter" },
      -- TODO:
      args = { "-r", file, "-t", test_file },
    }
  end,
  condition = {
    filetype = { "txt" },
  },
}
