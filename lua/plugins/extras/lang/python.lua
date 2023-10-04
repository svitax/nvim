-- local augroup = vim.api.nvim_create_augroup
-- local autocmd = vim.api.nvim_create_autocmd

return {
  { "gabenespoli/vim-jupycent", ft = { "json" }, event = "VeryLazy" },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim", --[["mfussenegger/nvim-dap-python"]]
    },
    cmd = "VenvSelect",
    keys = {
      { "<leader>pv", "<cmd>VenvSelect<cr>", desc = "Switch venv" },
      { "<leader>pV", "<cmd>lua require('venv-selector').deactivate_venv()<cr>", desc = "Deactivate venv" },
    },
    opts = {
      auto_refresh = true,
      search_venv_managers = true,
      search_workspace = true,
      search = false,
      -- search_workspace = true,
      -- search = true, --[[dap_enabled = true,]]
      name = { "env", "venv", ".venv" },
      -- enable_debug_output = true,
    },
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
  --   dependencies = { "MunifTanjim/nui.nvim" },
  --   event = "BufEnter",
  --   opts = {
  --     get_venvs = function(venvs_path)
  --       return require("swenv.api").get_venvs(venvs_path)
  --     end,
  --     -- venvs_path = vim.fn.expand("~/.conda/envs"),
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
    -- dependencies = { "folke/neoconf.nvim", "rafi/neoconf-venom.nvim" },
    -- config = function(_, opts)
    --   require("venom").setup()
    --   require("lazy.core.config").plugins["nvim-lspconfig"].config()
    -- end,
    opts = function(_, opts)
      local caps = vim.lsp.protocol.make_client_capabilities()
      local path = require("mason-core.path")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local util = require("lspconfig/util")

      local root_files = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
      }

      local _package = ""

      local py = {}
      function py.get_pdm_package()
        return vim.fn.trim(vim.fn.system("pdm info --packages"))
      end

      function py.pep582(root_dir)
        local pdm_match = vim.fn.glob(path.join(root_dir, "pdm.lock"))
        if pdm_match ~= "" then
          _package = py.get_pdm_package()
        end

        if _package ~= "" then
          return path.join(_package, "lib")
        end
      end

      -- caps = cmp_nvim_lsp.default_capabilities(caps)
      -- caps.textDocument.completion.completionItem.snippetSupport = true
      -- caps.textDocument.onTypeFormatting = { dynamicRegistration = false }
      -- caps.offsetEncoding = { "utf-16" }

      opts.servers.pylance = {
        capabilities = { textDocument = { publishDiagnostics = { tagSupport = { valueSet = { 2 } } } } },
        -- capabilities = caps,
        on_init = function(client)
          client.config.settings.python.pythonPath = (function(workspace)
            if vim.env.VIRTUAL_ENV then
              return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
            end
            if vim.fn.filereadable(path.concat({ workspace, "poetry.lock" })) then
              local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
              return path.concat({ venv, "bin", "python" })
            end
            local pep582 = py.pep582(client)
            if pep582 ~= nil then
              client.config.settings.python.analysis.extraPaths = { pep582 }
            end
            return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
          end)(client.config.root_dir)
        end,
        before_init = function(_, config)
          config.settings.python.analysis.stubPath = path.concat({
            vim.fn.stdpath("data"),
            "lazy",
            "python-type-stubs",
          })
        end,
      }

      -- opts.servers.jedi_language_server = {
      --   filetypes = { "python" },
      --   init_options = {
      --     jediSettings = {
      --       case_insensitive_completion = true,
      --       add_bracket_after_function = true,
      --       dynamic_params = true,
      --       -- Allot of machine learning models that are set from default.
      --       autoImportModules = { "torch" },
      --     },
      --   },
      --   before_init = function(_, config)
      --     local stub_path = require("lspconfig/util").path.join(
      --       vim.fn.stdpath("data"),
      --       "site",
      --       "pack",
      --       "packer",
      --       "typings",
      --       "opt",
      --       "python-type-stubs"
      --     )
      --     config.settings.python.analysis.stubPath = stub_path
      --   end,
      --   on_new_config = function(new_config, new_root_dir)
      --     new_config.settings.python.pythonPath = vim.fn.exepath("python") or vim.fn.exepath("python3") or "python"
      --     new_config.cmd_env.PATH = py.env(new_root_dir) .. new_config.cmd_env.PATH
      --
      --     local pep582 = py.pep582(new_root_dir)
      --     if pep582 ~= nil then
      --       new_config.settings.python.analysis.extraPaths = { pep582 }
      --     end
      --   end,
      -- }

      --@type lspconfig.options.pylsp
      -- opts.servers.pylsp = {
      --   settings = {
      --     pylsp = {
      --       configurationSources = { "flake8" },
      --       plugins = {
      --         preload = { enabled = false, modules = {} },
      --         pyflakes = { enabled = false },
      --         mccabe = { enabled = false, threshold = 15 },
      --         pycodestyle = {
      --           maxLineLength = 99,
      --           ignore = {
      --             "E226",
      --             "E266",
      --             "E302",
      --             "E303",
      --             "E304",
      --             "E305",
      --             "E402",
      --             "C0103",
      --             "W0104",
      --             "W0621",
      --             "W391",
      --             "W503",
      --             "W504",
      --           },
      --         },
      --         pydocstyle = { enabled = false },
      --         autopep8 = { enabled = false },
      --         yapf = { enabled = false },
      --         flake8 = { enabled = false },
      --         pylint = { enabled = false },
      --         rope = { enabled = true },
      --         rope_completion = { enabled = false, eager = false },
      --         rope_autoimport = { enabled = false, memory = true },
      --         ruff = { enabled = true },
      --         -- mypy = { enabled = false },
      --         black = { enabled = true },
      --         isort = { enabled = true },
      --
      --         -- jedi = {},
      --         jedi_completion = {
      --           enabled = true,
      --           fuzzy = true,
      --           include_params = true,
      --           include_class_objects = true,
      --           include_function_objects = true,
      --         },
      --         jedi_definition = { enabled = true },
      --         jedi_hover = { enabled = true },
      --         jedi_references = { enabled = true },
      --         jedi_signature_help = { enabled = true },
      --         jedi_symbols = { enabled = true, all_scopes = true },
      --       },
      --     },
      --   },
      --   root_dir = function(fname)
      --     local root_files = {
      --       "pyproject.toml",
      --       "setup.py",
      --       "setup.cfg",
      --       "requirements.txt",
      --       "Pipfile",
      --     }
      --     return util.root_pattern(unpack(root_files))(fname)
      --       or util.find_git_ancestor(fname)
      --       or util.path.dirname(fname)
      --   end,
      --   on_init = function(client)
      --     client.config.settings.python.pythonPath = (function(workspace)
      --       if vim.env.VIRTUAL_ENV then
      --         return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
      --       end
      --       if vim.fn.filereadable(path.concat({ workspace, "poetry.lock" })) then
      --         local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
      --         return path.concat({ venv, "bin", "python" })
      --       end
      --       local pep582 = py.pep582(client)
      --       if pep582 ~= nil then
      --         client.config.settings.python.analysis.extraPaths = { pep582 }
      --       end
      --       return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
      --     end)(client.config.root_dir)
      --   end,
      --   before_init = function(_, config)
      --     config.settings.python.analysis.stubPath = path.concat({
      --       vim.fn.stdpath("data"),
      --       "lazy",
      --       "python-type-stubs",
      --     })
      --   end,
      -- }

      -- will be automatically installed with mason and loaded with lspconfig
      -- ---@type lspconfig.options.pyright
      -- opts.servers.pyright = {
      --   settings = {
      --     -- pyright = { autoImportCompletions = true },
      --     python = {
      --       analysis = {
      --         autoSearchPaths = true,
      --         useLibraryCodeForTypes = true,
      --         diagnosticMode = "openFilesOnly",
      --         --       -- INFO: use mypy for type checking
      --         --       typeCheckingMode = "off",
      --         --       useLibraryCodeForTypes = true,
      --         --       diagnosticSeverityOverrides = {
      --         --         -- reportGeneralTypeIssues = "none",
      --         --         -- reportOptionalMemberAccess = "none",
      --         --         -- reportOptionalSubscript = "none",
      --         --         -- reportPrivateImportUsage = "none",
      --         --         reportUndefinedVariable = "none",
      --         --         reportUnusedImport = "none",
      --         --         reportUnusedVariable = "none",
      --         --         reportMissingTypeStubs = "none",
      --         --       },
      --         -- autoImportCompletions = false,
      --       },
      --     },
      --   },
      -- }
      opts.servers.sourcery = {
        init_options = { token = os.getenv("SOURCERY_TOKEN"), extension_version = "vim.lsp", editor_version = "vim" },
        filetypes = {
          "python", --[[ "javascript", "javascriptreact", "typescript", "typescriptreact"]]
        },
        root_dir = util.root_pattern(unpack(root_files)),
        on_init = function(client)
          client.config.settings.python.pythonPath = (function(workspace)
            if vim.env.VIRTUAL_ENV then
              return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
            end
            if vim.fn.filereadable(path.concat({ workspace, "poetry.lock" })) then
              local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
              return path.concat({ venv, "bin", "python" })
            end
            local pep582 = py.pep582(client)
            if pep582 ~= nil then
              client.config.settings.python.analysis.extraPaths = { pep582 }
            end
            return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
          end)(client.config.root_dir)
        end,
        before_init = function(_, config)
          config.settings.python.analysis.stubPath = path.concat({
            vim.fn.stdpath("data"),
            "lazy",
            "python-type-stubs",
          })
        end,
      }

      opts.servers.ruff_lsp = {
        root_dir = util.root_pattern(unpack(root_files)),
        on_new_config = function(config, new_workspace)
          config.settings.python.pythonPath = vim.fn.exepath("python") or vim.fn.exepath("python3") or "python"
          config.cmd_env.PATH = py.env(new_workspace) .. new_workspace.cmd_env.PATH
          return config
        end,
        init_options = { settings = { args = {} } },
        on_init = function(client)
          client.config.settings.python.pythonPath = (function(workspace)
            if vim.env.VIRTUAL_ENV then
              return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
            end
            if vim.fn.filereadable(path.concat({ workspace, "poetry.lock" })) then
              local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
              return path.concat({ venv, "bin", "python" })
            end
            local pep582 = py.pep582(client)
            if pep582 ~= nil then
              client.config.settings.python.analysis.extraPaths = { pep582 }
            end
            return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
          end)(client.config.root_dir)
        end,
        before_init = function(_, config)
          config.settings.python.analysis.stubPath = path.concat({
            vim.fn.stdpath("data"),
            "lazy",
            "python-type-stubs",
          })
        end,
      }

      ----@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      opts.setup = {
        ruff_lsp = function(_, opts)
          require("lazyvim.util").on_attach(function(client, buffer)
            local sc = client.server_capabilities
            if client.name == "ruff_lsp" then
              sc.hoverProvider = false
            end
          end)
        end,
        sourcery = function(_, opts)
          require("lazyvim.util").on_attach(function(client, buffer)
            local sc = client.server_capabilities
            if client.name == "sourcery" then
              sc.hoverProvider = false
            end
          end)
        end,
        -- pyright = function(_, opts)
        --   require("lazyvim.util").on_attach(function(client, buffer)
        --     local rc = client.server_capabilities
        --     if client.name == "pyright" then
        --       rc.diagnosticProvider = false
        --       rc.definitionProvider = false
        --       rc.signatureHelpProvider = false -- pyright/pylance typing of signature is weird
        --       rc.completionProvider = false
        --       rc.renameProvider = false -- rope is ok
        --       rc.hoverProvider = false -- pylsp also includes docstrings
        --     end
        --   end)
        -- end,
        pylance = function(_, opts)
          require("lazyvim.util").on_attach(function(client, buffer)
            local sc = client.server_capabilities
            if client.name == "pylance" then
              -- sc.definitionProvider = false
              -- sc.signatureHelpProvider = false
              -- sc.completionProvider = false
              -- sc.renameProvider = false -- rope is ok
              -- sc.hoverProvider = false -- pylsp also includes docstrings
              -- sc.signatureHelpProvider = false -- pyright/pylance typing of signature is weird
              sc.definitionProvider = true -- pyright doesn not follow imports correctly
              sc.referencesProvider = true -- pylsp does it
              sc.completionProvider = { resolveProvider = true, triggerCharacters = { "." } }
            end
          end)
        end,
        -- pylsp = function(_, opts)
        --   require("lazyvim.util").on_attach(function(client, buffer)
        --     local sc = client.server_capabilities
        --     if client.name == "pylsp" then
        --       -- sc.renameProvider = false
        --       -- sc.hoverProvider = false
        --       -- sc.completionProvider = false
        --       sc.documentFormattingProvider = false
        --       sc.documentRangeFormattingProvider = false
        --     end
        --   end)
        -- end,
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- "mypy",
        "black",
        "ruff",
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
      -- add pylance to registry
      local sources = require("mason-registry.sources")
      require("plugins.extras.pylance")
      sources.set_registries({ "lua:mason-registry.index" })

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
    "nvimtools/none-ls.nvim",
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
      -- TODO: use usort until ruff_lsp supports sorting imports with vim.lsp.buf.format() and not just code actions
      -- table.insert(opts.sources, nls.builtins.formatting.usort)
      table.insert(opts.sources, nls.builtins.formatting.ruff)
      table.insert(opts.sources, nls.builtins.formatting.black)
      -- table.insert(opts.sources, nls.builtins.diagnostics.pydocstyle)
      -- table.insert(opts.sources, nls.builtins.diagnostics.pylint)
    end,
  },
  -- {
  --   "mfussenegger/nvim-dap",
  --   -- optional = true,
  --   dependencies = {
  --     {
  --       "mfussenegger/nvim-dap-python",
  --       opts = { include_configs = true, console = "internalConsole" },
  --       keys = {
  --         -- stylua: ignore
  --         { "<leader>dPt", function() require("dap-python").test_method() end, desc = "Debug Method" },
  --         -- stylua: ignore
  --         { "<leader>dPc", function() require("dap-python").test_class() end, desc = "Debug Class" },
  --       },
  --       config = function(_, opts)
  --         local path = require("mason-registry").get_package("debugpy"):get_install_path()
  --         -- require("dap-python").setup("~/.virtualenvs/debugpy/bin/python", opts)
  --         require("dap-python").setup(path .. "venv/bin/python", opts)
  --       end,
  --     },
  --   },
  -- },
}
