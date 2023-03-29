local dap_vscode_ok, dap_vscode = pcall(require, "dap-vscode-js")
if not dap_vscode_ok then
  vim.notify("dap-vscode-js not installed!")
  return
end

return {
  setup = function(dap)
    dap.adapters.node2 = {
      type = "executable",
      command = "node",
      args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
    }

    dap.adapters.go = {
      type = "server",
      port = "${port}",
      executable = {
        command = vim.fn.stdpath("data") .. "/mason/bin/dlv",
        args = { "dap", "-l", "127.0.0.1:${port}" },
      },
    }

    -- NOTE: Python adapter managed by nvim-dap-python
    -- dap.adapters.python = {
    --   type = "executable",
    --   command = "python",
    --   args = { "-m", "debugpy.adapter" },
    -- }

    dap.adapters.nlua = function(callback, config)
      callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
    end

    -- The VSCode Debugger requires a special setup
    dap_vscode.setup({
      adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      debugger_path = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter", -- Path to VSCode Debugger
      debugger_cmd = { "js-debug-adapter" },
    })
  end,
}
