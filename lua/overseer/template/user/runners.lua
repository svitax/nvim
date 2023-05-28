local filerunners = {
  -- These are handled better by julia specific provider
  -- julia = {
  --     name = "Julia",
  --     repl = "julia",
  --     projectRepl = { "julia", "--threads=auto", "--project" },
  --     filerunner = function() return { "julia", vim.fn.expand("%:p") } end,
  -- },
  go = {
    name = "Go",
    filerunner = function()
      return { "go", "run", vim.fn.expand("%:p") }
    end,
  },
  sh = {
    name = "Shell",
    repl = "sh",
    filerunner = function()
      return { "sh", vim.fn.expand("%:p") }
    end,
  },
  bash = {
    name = "Bash",
    repl = "bash",
    filerunner = function()
      return { "bash", vim.fn.expand("%:p") }
    end,
  },
  zsh = {
    name = "Zsh",
    repl = "zsh",
    filerunner = function()
      return { "zsh", vim.fn.expand("%:p") }
    end,
  },
  fish = {
    name = "Fish",
    repl = "fish",
    filerunner = function()
      return { "fish", vim.fn.expand("%:p") }
    end,
  },
  python = {
    name = "Python",
    repl = "ipython",
    filerunner = function()
      return { "python", vim.fn.expand("%:p") }
    end,
  },
  rust = {
    name = "Rust",
    repl = "irust",
    filerunner = function()
      return { "rustc", vim.fn.expand("%:p") }
    end,
  },
  lua = {
    name = "Lua",
    repl = "lua",
    filerunner = function()
      return { "lua", vim.fn.expand("%:p") }
    end,
  },
  javascript = {
    name = "Javascript",
    repl = "node",
    filerunner = function()
      return { "node", vim.fn.expand("%:p") }
    end,
  },
  html = {
    name = "HTML",
    filerunner = function()
      return { "browser", vim.fn.expand("%:p") }
    end,
  },
}

return {
  condition = { filetype = vim.tbl_keys(filerunners) },
  generator = function(_, cb)
    local ft = filerunners[vim.bo.filetype]
    local ret = {}
    if ft.filerunner then
      table.insert(ret, {
        name = "Run " .. ft.name .. " file (" .. vim.fn.expand("%:t") .. ")",
        builder = function()
          return {
            cmd = ft.filerunner(),
            name = "Running " .. vim.fn.expand("%:t:r"),
            components = { "default", "unique" },
            -- components = { "default", "unique", "user.start_open" },
          }
        end,
        priority = 4,
      })
    end
    if ft.repl then
      table.insert(ret, {
        name = "Open " .. ft.name .. " REPL",
        builder = function()
          if ft.num then
            ft.num = ft.num + 1
          else
            ft.num = 1
          end
          return {
            cmd = ft.repl,
            name = ft.name .. " REPL " .. ft.num,
            components = {
              "default",
              -- {
              --   "user.start_open",
              --   start_insert = true,
              -- },
            },
          }
        end,
        priority = 5,
      })
    end
    cb(ret)
  end,
}
