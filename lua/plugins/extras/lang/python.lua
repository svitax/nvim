local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    cmd = "VenvSelect",
    keys = { { "<leader>pv", "<cmd>VenvSelect<cr>", desc = "Switch venv" } },
    opts = { search_workspace = true, search = false, dap_enabled = true, name = { ".venv" } },
    -- init = function()
    --   -- Array of file names indicating root directory. Modify to your liking
    --   local root_names = { ".git", "Makefile", "pyproject.toml" }
    --   -- Cache to use for speed up (at cost of possibly outdated results)
    --   local root_cache = {}
    --   augroup("auto_root", {})
    --   autocmd("BufEnter", {
    --     desc = "Auto change current directory (vim-rooter)",
    --     group = "auto_root",
    --     callback = function()
    --       -- Get directory path to start search from
    --       local path = vim.api.nvim_buf_get_name(0)
    --       if path == "" then
    --         return
    --       end
    --       path = vim.fs.dirname(path)
    --
    --       -- Try cache and resort to searching upward for root directory
    --       local root = root_cache[path]
    --       if root == nil then
    --         local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
    --         if root_file == nil then
    --           return
    --         end
    --         root = vim.fs.dirname(root_file)
    --         root_cache[path] = root
    --       end
    --
    --       -- Set current directory and
    --       -- If new cwd has a pyproject.toml file, activate cached venv from venv-selector
    --       -- I'm auto activating venvs like this because the DirChanged event isn't firing when I auto root like this
    --       -- Downside is we're setting venv every time we navigate to a buffer in a python project, when really we only need to do it once
    --       if vim.fn.chdir(root) and (vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";") ~= "") then
    --         require("venv-selector").retrieve_from_cache()
    --       end
    --     end,
    --   })
    -- end,
  },
  -- {
  --   "AckslD/swenv.nvim",
  --   opts = {
  --     venvs_path = vim.fn.expand("~/.conda/envs"),
  --     -- venvs_path = vim.fn.expand("~/.cache/pypoetry/virtualenvs/"),
  --     post_set_venv = function()
  --       vim.cmd("LspRestart")
  --     end,
  --   },
  --   keys = { { "<leader>pv", "<cmd>lua require('swenv.api').pick_venv()<cr>", desc = "Switch venv" } },
  -- },
  { "raimon49/requirements.txt.vim", event = "BufReadPre requirements*.txt" },
  -- add python to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "python" }, 0, #opts.ensure_installed)
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    -- dependencies = "rafi/neoconf-venom.nvim",
    -- config = function(_, opts)
    --   require("venom").setup()
    --   require('lazy.core.config').plugins["nvim-lspconfig"].config()
    -- end,
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        ---@type lspconfig.options.pylsp
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pyflakes = { enabled = false },
                mccabe = { enabled = false },
                pycodestyle = {
                  maxLineLength = 99,
                  ignore = {
                    "E226",
                    "E266",
                    "E302",
                    "E303",
                    "E304",
                    "E305",
                    "E402",
                    "C0103",
                    "W0104",
                    "W0621",
                    "W391",
                    "W503",
                    "W504",
                  },
                },
                pydocstyle = { enabled = false },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                flake8 = { enabled = false },
                pylint = { enabled = false },
                rope = { enabled = true },
                rope_completion = { enabled = false },
                rope_autoimport = { enabled = false },
                ruff = { enabled = true },
                -- mypy = { enabled = false },
                black = { enabled = true },
                isort = { enabled = true },
              },
            },
          },
        },
        -- will be automatically installed with mason and loaded with lspconfig
        ---@type lspconfig.options.pyright
        pyright = {
          settings = {
            -- pyright = { autoImportCompletions = true },
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                --       -- INFO: use mypy for type checking
                --       typeCheckingMode = "off",
                --       useLibraryCodeForTypes = true,
                --       diagnosticSeverityOverrides = {
                --         -- reportGeneralTypeIssues = "none",
                --         -- reportOptionalMemberAccess = "none",
                --         -- reportOptionalSubscript = "none",
                --         -- reportPrivateImportUsage = "none",
                --         reportUndefinedVariable = "none",
                --         reportUnusedImport = "none",
                --         reportUnusedVariable = "none",
                --         reportMissingTypeStubs = "none",
                --       },
                -- autoImportCompletions = false,
              },
            },
          },
        },
        sourcery = {
          init_options = { token = os.getenv("SOURCERY_TOKEN") },
          filetypes = {
            "python", --[[ "javascript", "javascriptreact", "typescript", "typescriptreact"]]
          },
        },
        -- ruff_lsp = { init_options = { settings = { args = {}, organizeImports = true, fixAll = true } } },
        -- ruff_lsp = {},
      },
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- ruff_lsp = function(_, opts)
        --   require("lazyvim.util").on_attach(function(client, buffer)
        --     local rc = client.server_capabilities
        --     if client.name == "ruff_lsp" then
        --       rc.hoverProvider = false
        --     end
        --   end)
        -- end,
        sourcery = function(_, opts)
          require("lazyvim.util").on_attach(function(client, buffer)
            local rc = client.server_capabilities
            if client.name == "sourcery" then
              rc.hoverProvider = false
            end
          end)
        end,
        pyright = function(_, opts)
          require("lazyvim.util").on_attach(function(client, buffer)
            local rc = client.server_capabilities
            if client.name == "pyright" then
              rc.definitionProvider = false
              rc.signatureHelpProvider = false
              -- rc.completionProvider = false
            end
          end)
        end,
        pylsp = function(_, opts)
          require("lazyvim.util").on_attach(function(client, buffer)
            local rc = client.server_capabilities
            if client.name == "pylsp" then
              rc.renameProvider = false
              rc.hoverProvider = false
              rc.completionProvider = false
            end
          end)
        end,
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- "mypy",
        -- "black",
        -- "ruff",
        -- "usort",
        -- "pylint",
        -- "pydocstyle",
        -- "flake8",
        -- "vulture",
        -- "pylama",
        -- "ruff-lsp", -- installed by including in nvim-lspconfig opts
        -- "pyright", -- installed by including in nvim-lspconfig opts
        -- "sourcery", -- installed by including in nvim-lspconfig opts
      }, 0, #opts.ensure_installed)
      -- This is needed for pylint to work in a virtualenv. See https://github.com/williamboman/mason.nvim/issues/668#issuecomment-1320859097
      -- PATH = "append"
    end,
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(plugin, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end

      local pylsp = require("mason-registry").get_package("python-lsp-server")

      pylsp:on("install:success", function()
        -- Install pylsp plugins...
        vim.schedule(function()
          local install_cmd = {
            vim.fn.expand("~/.local/share/nvim/mason/packages/python-lsp-server/venv/bin/python"),
            "-m",
            "pip",
            "install",
            "python-lsp-black",
            "python-lsp-ruff",
            -- "pylsp-mypy",
            "pylsp-rope",
            "pyls-isort",
          }
          vim.fn.system(install_cmd)
          -- vim.notify("python-lsp-server plugins installed", "info", { title = "mason.nvim" })
        end)
      end)
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      -- table.insert(
      --   opts.sources,
      --   nls.builtins.diagnostics.mypy.with({
      --     prefer_local = ".venv/bin",
      --     extra_args = { "--strict" },
      --     -- method = nls.methods.DIAGNOSTICS_ON_SAVE,
      --   })
      -- )
      -- table.insert(opts.sources, nls.builtins.formatting.black)
      -- TODO: use usort until ruff_lsp supports sorting imports with vim.lsp.buf.format() and not just code actions
      -- table.insert(opts.sources, nls.builtins.formatting.usort)
      -- table.insert(opts.sources, nls.builtins.diagnostics.pydocstyle)
      -- table.insert(opts.sources, nls.builtins.diagnostics.pylint)
    end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "mfussenegger/nvim-dap-python",
        opts = { include_configs = true, console = "internalConsole" },
        keys = {
          -- stylua: ignore
          { "<leader>dPt", function() require("dap-python").test_method() end, desc = "Debug Method" },
          -- stylua: ignore
          { "<leader>dPc", function() require("dap-python").test_class() end, desc = "Debug Class" },
        },
        config = function(_, opts)
          local path = require("mason-registry").get_package("debugpy"):get_install_path()
          -- require("dap-python").setup("~/.virtualenvs/debugpy/bin/python", opts)
          require("dap-python").setup(path .. "venv/bin/python", opts)
        end,
      },
    },
  },
}
