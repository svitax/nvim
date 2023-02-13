--
-- PAPIS | TELESCOPE
--
--
-- Papis Telescope picker
--
-- Adapted from: https://github.com/nvim-telescope/telescope-bibtex.nvim

local telescope = require("telescope")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local actions = require("telescope.actions")
local previewers = require("telescope.previewers")
local telescope_config = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
-- local papis_actions = require("telescope._extensions.papis.actions")
local Path = require("plenary.path")
local NuiLine = require("nui.line")

-- local utils = require("papis.utils")
-- local db = require("papis.sqlite-wrapper")
-- if not db then
--   return nil
-- end
--
-- local wrap, preview_format, required_db_keys

---Gets the cite format for the filetype
---@return string #The cite format for the filetype (or fallback if undefined)
-- local function parse_format_string()
--   local cite_format = utils.get_cite_format(vim.bo.filetype)
--   if type(cite_format) == "table" then
--     cite_format = cite_format[1]
--   end
--   return cite_format
-- end

local M = {}

---Gets the file names given a list of full paths
---@param full_paths table|nil #A list of paths or nil
---@return table #A list of file names
function M.get_filenames(full_paths)
  local filenames = {}
  if full_paths then
    for _, full_path in ipairs(full_paths) do
      local filename = Path:new(full_path):_split()
      filename = filename[#filename]
      table.insert(filenames, filename)
    end
  end
  return filenames
end

---Defines the papis.nvim telescope picker
---@param opts table #Options for the papis picker
function M.papis_picker(opts)
  opts = opts or {}

  local scan = require("plenary.scandir")
  local files = {}
  local scanned_files = scan.scan_dir(vim.fn.expand("%:p:h"), { hidden = true, depth = 2 })

  for _, file in ipairs(scanned_files) do
    table.insert(files, { name = vim.fn.fnamemodify(file, ":t"), path = file })
  end

  pickers
    .new(opts, {
      prompt_title = "Citar References",
      finder = finders.new_table({
        results = files,
        entry_maker = function(entry)
          -- local entry_pre_calc = db["search"]:get(entry["id"])[1]
          -- local items = entry_pre_calc["items"]
          --
          -- local displayer_tbl = entry_pre_calc["displayer_tbl"]
          --
          local displayer = entry_display.create({
            separator = "",
            items = {
              { width = opts.bufnr_width },
              { remaining = true },
            },
          })
          local make_display = function()
            return displayer({
              { entry.name, entry.name },
              { entry.name, entry.name },
            })
          end
          -- local search_string = entry_pre_calc["search_string"]
          return {
            value = entry,
            -- display = entry.name,
            display = make_display,
            -- ordinal = search_string,
            ordinal = entry.name,
            -- id = entry,
          }
        end,
      }),
      previewer = previewers.new_buffer_previewer({
        define_preview = function(self, entry, status)
          local previewer_entry = vim.deepcopy(entry)
          local line = NuiLine()
          line:append(entry.value.name)
          line:render(self.state.bufnr, -1, 1)
          -- local clean_preview_format = utils.do_clean_format_tbl(preview_format, previewer_entry.id)
          --
          -- -- get only file names (not full path)
          -- if previewer_entry.id.notes then
          --   previewer_entry.id.notes = M.get_filenames(previewer_entry.id.notes)
          -- end
          -- if previewer_entry.id.files then
          --   previewer_entry.id.files = M.get_filenames(previewer_entry.id.files)
          -- end
          --
          -- local preview_lines = utils.make_nui_lines(clean_preview_format, previewer_entry.id)
          --
          -- for line_nr, line in ipairs(preview_lines) do
          --   line:render(self.state.bufnr, -1, line_nr)
          -- end

          -- vim.api.nvim_win_set_option(status.preview_win, "wrap", wrap)
        end,
      }),
      sorter = telescope_config.generic_sorter(opts),
      attach_mappings = function(_, map)
        -- actions.select_default:replace(papis_actions.ref_insert(format_string))
        -- map("i", "<c-o>", papis_actions.open_file())
        -- map("n", "o", papis_actions.open_file())
        -- map("i", "<c-n>", papis_actions.open_note())
        -- map("n", "n", papis_actions.open_note())
        -- map("i", "<c-e>", papis_actions.open_info())
        -- map("n", "e", papis_actions.open_info())
        -- Makes sure that the other defaults are still applied
        return true
      end,
    })
    :find()
end

return M

-- return telescope.register_extension({
--   -- setup = function(opts)
--   --   wrap = opts["wrap"]
--   --   preview_format = opts["preview_format"]
--   --   local search_keys = opts["search_keys"]
--   --   local results_format = opts["results_format"]
--   --   required_db_keys = utils:get_required_db_keys({ search_keys, preview_format, results_format })
--   -- end,
--   exports = {
--     citar = papis_picker,
--   },
-- })
--
--
--
-- WARNING: first attempt at making bibliography picker
-- Find bibliography
-- {
--   "<leader>nb",
--   lv_utils.telescope("files", {
--     attach_mappings = function(prompt_bufnr, map)
--       require("telescope.actions").select_default:replace(function()
--         local function get_selected_files(smart)
--           smart = vim.F.if_nil(smart, true)
--           local selected = {}
--           local current_picker = action_state.get_current_picker(prompt_bufnr)
--           local selections = current_picker:get_multi_selection()
--           if smart and vim.tbl_isempty(selections) then
--             table.insert(selected, action_state.get_selected_entry())
--           else
--             for _, selection in ipairs(selections) do
--               table.insert(selected, Path:new(selection[1]))
--             end
--           end
--           selected = vim.tbl_map(function(entry)
--             return Path:new(entry.path)
--           end, selected)
--           return selected
--         end
--         local selections = get_selected_files(true)
--
--         if vim.tbl_isempty(selections) then
--           vim.notify("No selection to be opened!")
--           return
--         end
--
--         local cmd = vim.fn.has("win32") == 1 and "start" or vim.fn.has("mac") == 1 and "open" or "xdg-open"
--         for _, selection in ipairs(selections) do
--           require("plenary.job")
--             :new({
--               command = cmd,
--               args = { selection:absolute() },
--             })
--             :start()
--         end
--         actions.close(prompt_bufnr)
--       end)
--       return true
--     end,
--     cwd = "~/Desktop/docs/books",
--   }),
--   desc = "Bibliography",
-- },
--
-- WARNING:second attempt using telescope-bibtex
-- {
--   "<leader>fb",
--   function()
--     local actions = require("telescope.actions")
--     local action_state = require("telescope.actions.state")
--     local Path = require("plenary.path")
--     local Job = require("plenary.job")
--     require("telescope._extensions.bibtex").exports.bibtex({
--       attach_mappings = function(prompt_bufnr, map)
--         require("telescope.actions").select_default:replace(function()
--           local entry = action_state.get_selected_entry().id.content
--           -- print(vim.inspect(action_state.get_selected_entry()))
--           local cmd = vim.fn.has("win32") == 1 and "start" or vim.fn.has("mac") == 1 and "open" or "xdg-open"
--           for _, line in pairs(entry) do
--             local match_base = "%f[%w]file"
--             local s = line:match(match_base .. "%s*=%s*%b{}")
--               or line:match(match_base .. '%s*=%s*%b""')
--               or line:match(match_base .. "%s*=%s*%d+")
--               or line:match("%s*books/[^\n]+")
--             if s ~= nil then
--               -- s = s:match("%b{}") or s:match('%b""') or s:match("%d+")
--               s = "/home/svitax/Desktop/docs/" .. (s:match("%{(.-)%}") or s:match("(books/[^\n]+)"))
--               -- print(s)
--               Job:new({
--                 command = cmd,
--                 args = { s },
--                 detached = true,
--               }):start()
--               break
--             end
--           end
--           actions.close(prompt_bufnr)
--         end)
--         return true
--       end,
--     })
--   end,
--   desc = "Bibliography",
-- },
