local utils = require("utils")
local lv_utils = require("lazyvim.util")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local from_entry = require("telescope.from_entry")

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

M.config_picker = function(opts)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = "Configuration files",
      finder = finders.new_table({
        results = {
          { "fish", "~/.config/fish/config.fish", cd = true },
          { "git", "~/.gitconfig", cd = true },
          { "lf", "~/.config/lf/lfrc", cd = true },
          { "pistol", "~/.config/pistol/pistol.conf", cd = true },
          { "starship", "~/.config/starship.toml", cd = true },
          { "tmux", "~/.config/tmux/tmux.conf", cd = true },
          { "wezterm", "~/.config/wezterm/wezterm.lua", cd = true },
          { "yazi", "~/.config/yazi/yazi.toml", cd = true },
        },
        entry_maker = function(entry)
          return {
            value = entry[1],
            display = entry[1],
            ordinal = entry[1],
            path = vim.fn.expand(entry[2]),
            cd = entry.cd or false,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      previewer = conf.file_previewer(opts),
      attach_mappings = function(prompt_bufnr, map)
        map("i", "<c-f>", function()
          local selection = action_state.get_selected_entry()
          local dir = from_entry.path(selection)
          local base_dir = vim.fn.fnamemodify(dir, ":h")

          actions.close(prompt_bufnr)
          vim.schedule(function()
            lv_utils.telescope(
              "files",
              vim.tbl_extend("force", opts, { prompt_title = "Find files in " .. dir, cwd = base_dir })
            )()
          end)
        end)
        map("i", "<c-s>", function()
          local selection = action_state.get_selected_entry()
          local dir = from_entry.path(selection)
          local base_dir = vim.fn.fnamemodify(dir, ":h")

          actions.close(prompt_bufnr)
          require("telescope").extensions.live_grep_args.live_grep_args({
            cwd = base_dir,
            prompt_title = "Search (args) in " .. base_dir,
            attach_mappings = function(_, lmap)
              lmap("i", "<c-l>", require("telescope-live-grep-args.actions").quote_prompt())
              lmap("i", "<c-;>", require("telescope-live-grep-args.actions").quote_prompt({ postfix = " -t" }))
              lmap("i", "<c-o>", require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " }))
              return true
            end,
          })
        end)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()

          if selection.cd then
            vim.cmd.cd(vim.fs.dirname(selection.path))
          end
          vim.cmd.edit(selection.path) -- edit file
        end)
        return true
      end,
    })
    :find()
end

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
