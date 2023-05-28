return {
  -- TODO: this condition doesn't work
  condition = { dir = "/home/svitax/.config/nvim" },
  generator = function(_, cb)
    local ret = {
      {
        name = "View LSP Logs",
        builder = function()
          return {
            name = "View LSP Logs",
            cmd = "tail --follow --retry ~/.local/state/nvim/lsp.log | less -S",
            components = { "default", "unique", { "user.start_open", goto_prev = true } },
          }
        end,
        priority = 150,
        params = {},
      },
      {
        name = "View Neovim Logs",
        builder = function()
          return {
            name = "View Neovim Logs",
            cmd = "tail --follow --retry ~/.local/state/nvim/log | less -S",
            components = { "default", "unique", { "user.start_open", goto_prev = true } },
          }
        end,
        priority = 150,
        params = {},
      },
    }
    local logs = vim.fn.systemlist([[fd -e log]])
    for _, log in pairs(logs) do
      table.insert(ret, {
        name = "Show " .. log,
        builder = function()
          return {
            name = "Show " .. log,
            cmd = "tail --follow --retry " .. log,
            components = { "default", "unique", { "user.start_open", goto_prev = true } },
          }
        end,
        priority = 150,
        params = {},
      })
    end
    cb(ret)
  end,
}
