return {
  -- add rust to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "rust" })
      end
    end,
  },
  -- TODO: idk if this works?
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "saecki/crates.nvim" },
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.cmp_source_names["crates"] = "(crates)"

      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "crates" },
      }, 1, #opts.sources))
    end,
  },
  {
    "saecki/crates.nvim",
    -- after = "nvim-cmp",
    event = { "BufRead Cargo.toml" },
    opts = { null_ls = { enabled = true, name = "crates.nvim" } },
    config = function(_, opts)
      local crates = require("crates")
      crates.setup(opts)

      vim.keymap.set("n", "<leader>mt", crates.toggle, { buffer = true, desc = "Toggle crates.io info" })
      vim.keymap.set("n", "<leader>mr", crates.reload, { buffer = true, desc = "Reload crates.io info" })

      vim.keymap.set("n", "<leader>mv", crates.show_versions_popup, { buffer = true, desc = "Show crate versions" })
      vim.keymap.set("n", "<leader>mf", crates.show_features_popup, { buffer = true, desc = "Show crate features" })
      vim.keymap.set("n", "<leader>md", crates.show_dependencies_popup, { buffer = true, desc = "Show crate deps" })

      vim.keymap.set("n", "<leader>mu", crates.update_crate, { buffer = true, desc = "Update crate" })
      vim.keymap.set("v", "<leader>mu", crates.update_crates, { buffer = true, desc = "Update crates" })
      vim.keymap.set("n", "<leader>ma", crates.update_all_crates, { buffer = true, desc = "Update all crates" })
      vim.keymap.set("n", "<leader>mU", crates.upgrade_crate, { buffer = true, desc = "Upgrade crate" })
      vim.keymap.set("v", "<leader>mU", crates.upgrade_crates, { buffer = true, desc = "Upgrade crates" })
      vim.keymap.set("n", "<leader>mA", crates.upgrade_all_crates, { buffer = true, desc = "Upgrade all crates" })

      vim.keymap.set("n", "<leader>mH", crates.open_homepage, { buffer = true, desc = "Open crate homepage" })
      vim.keymap.set("n", "<leader>mR", crates.open_repository, { buffer = true, desc = "Open crate repository" })
      vim.keymap.set("n", "<leader>mD", crates.open_documentation, { buffer = true, desc = "Open crate documentation" })
      vim.keymap.set("n", "<leader>mC", crates.open_crates_io, { buffer = true, desc = "Open crates.io" })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "rust-analyzer",
        "rustfmt",
        "codelldb",
      }, 0, #opts.ensure_installed)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "simrat39/rust-tools.nvim" },
    opts = {
      -- make sure mason installs the server
      servers = { rust_analyzer = {} },
      setup = {
        rust_analyzer = function(_, opts)
          local rt = require("rust-tools")
          require("lazyvim.util").on_attach(function(client, buffer)
          -- stylua: ignore
          if client.name == "rust_analyzer" then
            -- vim.keymap.set("n", "K", "<cmd>RustHoverActions<cr>", { buffer = buffer, desc = "Hover Actions (Rust)" })
            vim.keymap.set("n", "<leader>ca", "<cmd>RustCodeAction<cr>", { buffer = buffer, desc = "Code Action (Rust)" })
            vim.keymap.set("n", "<leader>dr", "<cmd>RustDebuggables<cr>", { buffer = buffer, desc = "Run Debuggables (Rust)" })
          end
          end)
          local mason_registry = require("mason-registry")
          -- rust tools configuration for debugging support
          local codelldb = mason_registry.get_package("codelldb")
          local extension_path = codelldb:get_install_path() .. "/extension/"
          local codelldb_path = extension_path .. "adapter/codelldb"
          local liblldb_path = vim.fn.has("mac") == 1 and extension_path .. "lldb/lib/liblldb.dylib"
            or extension_path .. "lldb/lib/liblldb.so"
          local rust_tools_opts = vim.tbl_deep_extend("force", opts, {
            dap = {
              adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
            },
            tools = {
              on_initialized = function()
                vim.cmd([[
              augroup RustLSP
              autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
              autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
              autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
              augroup END
              ]])
              end,
            },
          })
          require("rust-tools").setup(rust_tools_opts)
          return true
        end,
        taplo = function(_, _)
          local crates = require("crates")
          local function show_documentation()
            if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
              crates.show_popup()
            else
              vim.lsp.buf.hover()
            end
          end
          require("lazyvim.util").on_attach(function(client, buffer)
          -- stylua: ignore
          if client.name == "taplo" then
            vim.keymap.set("n", "K", show_documentation, { buffer = buffer, desc = "Show Crate Documentation" })
          end
          end)
          return false -- make sure the base implementation calls taplo.setup
        end,
      },
    },
  },
}
