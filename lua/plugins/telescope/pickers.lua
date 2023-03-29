local utils = require("utils")
local lv_utils = require("lazyvim.util")

local preview_height = 0.80
local preview_width = 0.75

local git_icons = {
  added = "A",
  changed = "M",
  copied = "C",
  deleted = "-",
  renamed = "R",
  unmerged = "U",
  untracked = "?",
}

local M = {}

M.delta_previewer = require("telescope.previewers").new_termopen_previewer({
  get_command = function(entry)
    if entry.status == "??" then
      return { "bat", "--style=plain", entry.value }
    end
    return {
      "git",
      "-c",
      "core.pager=delta",
      "-c",
      "delta.paging=always",
      "-c",
      "delta.pager=less -R",
      "diff",
      "HEAD",
      "--",
      entry.value,
    }
  end,
})
M.delta_bcommits_previewer = require("telescope.previewers").new_termopen_previewer({
  get_command = function(entry)
    return {
      "git",
      "-c",
      "core.pager=delta",
      "-c",
      "delta.side-by-side=false",
      "diff",
      entry.value .. "^!",
      "--",
      entry.current_file,
    }
  end,
})

M.delta_branches_picker = lv_utils.telescope("git_branches", {
  attach_mappings = function(_, map)
    -- map("i", "<c-f>", require("telescope.extensions").changed_files.actions.find_changed_files)
    map("i", "<CR>", function(prompt_bufnr)
      local entry = require("telescope.actions.state").get_selected_entry()
      require("telescope.actions").close(prompt_bufnr)
      vim.cmd("DiffviewOpen " .. entry.name)
    end)
    return true
  end,
  previewer = M.delta_previewer,
  layout_config = { height = preview_height, preview_width = preview_width },
})

M.delta_commits_picker = lv_utils.telescope("git_commits", {
  attach_mappings = function(_, map)
    -- map("i", "<c-f>", require("telescope.extensions").changed_files.actions.find_changed_files)
    map("i", "<CR>", function(prompt_bufnr)
      local entry = require("telescope.actions.state").get_selected_entry()
      require("telescope.actions").close(prompt_bufnr)
      vim.cmd("DiffviewOpen " .. entry.value)
    end)
    return true
  end,
  previewer = {
    M.delta_bcommits_previewer,
    require("telescope.previewers").git_commit_message.new({}),
    require("telescope.previewers").git_commit_diff_as_was.new({}),
  },
  layout_config = { height = preview_height, preview_width = preview_width },
})

M.delta_bcommits_picker = lv_utils.telescope("git_bcommits", {
  previewer = {
    M.delta_bcommits_previewer,
    require("telescope.previewers").git_commit_message.new({}),
    require("telescope.previewers").git_commit_diff_as_was.new({}),
  },
  layout_config = { height = preview_height, preview_width = preview_width },
})

M.delta_status_picker = lv_utils.telescope("git_status", {
  git_icons = git_icons,
  previewer = M.delta_previewer,
  layout_config = { height = preview_height, preview_width = preview_width },
})

M.delta_stash_picker = lv_utils.telescope("git_stash", {
  previewer = M.delta_previewer,
  layout_config = { height = preview_height, preview_width = preview_width },
})

return M
