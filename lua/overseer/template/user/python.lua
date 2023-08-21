local files = require("overseer.files")

local is_in_project = function(opts)
  return files.exists(files.join(opts.dir, "pyproject.toml")) or files.exists(files.join(opts.dir), "poetry.toml")
end

return {
  generator = function(_, cb)
    local ret = {}

    table.insert(ret, {
      name = "PythonFormat",
      builder = function(params)
        local file = vim.fn.expand("%:p")
        local cmd = { "yapf", "--recursive", "--parallel", "--verbose", "--in-place", file }
        return {
          cmd = cmd,
          components = { { "on_output_quickfix", set_diagnostics = true }, "on_result_diagnostics", "default" },
        }
      end,
      condition = { filetype = { "python" } },
    })

    local commands = {
      {
        name = "Poetry run file (" .. vim.fn.expand("%:t:r") .. ")",
        task_name = "Poetry run file",
        cmd = "poetry run python " .. vim.fn.expand("%:p"),
        condition = { callback = is_in_project },
        unique = true,
      },
      {
        name = "Poetry run project",
        task_name = "Poetry run project",
        cmd = "poetry run start",
        condition = { callback = is_in_project },
        unique = true,
      },
      -- {
      --   name = "Poetry start",
      --   task_name = "Poetry start",
      --   cmd = "poetry run task start",
      --   condition = { callback = is_in_project },
      --   unique = true,
      -- },
      {
        name = "Poetry run pre-commit",
        task_name = "poetry run Project",
        cmd = "poetry run task lint",
        condition = { callback = is_in_project },
        unique = true,
      },
      {
        name = "Python test server",
        task_name = "Poetry run test",
        cmd = "python -m unittest discover",
        condition = { callback = is_in_project },
        is_test_server = true,
        hide = true,
        unique = true,
      },
      {
        name = "Create python venv",
        task_name = "Create python venv",
        cmd = { "python" },
        args = {
          "-m",
          "venv",
          vim.fs.find(".git", { file = true, directories = true, recursive = true, pattern = ".git" })[1],
        },
        unique = true,
        condition = { filetype = "python" },
      },
      {
        name = "Create workdir",
        unique = true,
        cmd = "mkdir -p /tmp/work",
        condition = { filetype = "python" },
      },

      {
        name = "Show python version",
        cmd = "python",
        args = " --version",
        unique = true,
        condition = { filetype = "python" },
      },

      {
        name = "Poetry freeze",
        cmd = "poetry export -f requirements.txt > requirements.txt --without-hashes",
        condition = { callback = is_in_project },
        unique = true,
      },
      {
        name = "Run main.py",
        cmd = "python main.py",
        components = { "default", "unique" },
        condition = {
          callback = function()
            return files.exists("main.py") or files.exists("__main__.py")
          end,
        },
      },
    }

    local priority = 0
    for _, command in pairs(commands) do
      local comps = { "on_output_summarize", "on_exit_set_status", "on_complete_notify", "on_complete_dispose" }

      table.insert(ret, {
        name = command.name,
        builder = function()
          return {
            name = command.task_name or command.name,
            cmd = command.cmd,
            components = comps,
            metadata = { is_test_server = command.is_test_server },
          }
        end,
        tags = command.tags,
        priority = priority,
        params = {},
        condition = command.condition,
      })
      priority = priority + 1
    end

    return ret
  end,
}
