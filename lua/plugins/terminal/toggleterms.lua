local utils = require("utils")
local lv_utils = require("lazyvim.util")

local M = {}

M.navi = function()
  require("toggleterm.terminal").Terminal
    :new({
      cmd = "navi",
      direction = "float",
      count = 7,
      name = "navi",
    })
    :toggle()
end

M.btop = function()
  require("toggleterm.terminal").Terminal
    :new({
      cmd = "btop",
      direction = "float",
      count = 8,
      name = "btop",
    })
    :toggle()
end

M.ugit = function()
  require("toggleterm.terminal").Terminal
    :new({
      cmd = "ugit",
      direction = "float",
      count = 9,
      name = "ugit",
    })
    :toggle()
end

M.git_absorb = function()
  require("toggleterm.terminal").Terminal
    :new({
      cmd = "git-absorb",
      direction = "float",
      count = 10,
      name = "git-absorb",
    })
    :toggle()
end

M.gh_poi = function()
  require("toggleterm.terminal").Terminal
    :new({
      cmd = "gh poi --dry-run",
      direction = "float",
      count = 11,
      name = "gh poi dry-run",
    })
    :toggle()
end

return M
