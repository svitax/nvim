-- if vim.fn.prevnonblank(".") ~= vim.fn.line(".") then
--   vim.cmd([[startinsert]])
-- end
--
-- local parser = vim.treesitter.language.get_lang("gitcommit")
-- if parser then
--   vim.treesitter.start(0, parser)
--   vim.cmd([[au BufUnload <buffer> lua vim.treesitter.stop(0)]])
-- end
