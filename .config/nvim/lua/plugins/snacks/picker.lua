local picker = require("snacks.picker")

local M = {}
---@module "lazy"
---@type LazyKeysSpec[]
M.keys = {
  -- stylua: ignore start
	{ "<space>fb", function() picker.buffers() end, desc = "Picker: Buffers" },
  { "<space>fd", function() picker.diagnostics() end, desc = "Picker: Diagnostics" },
  { "<space>fR", function() picker.resume() end, desc = "Picker: Resume" },
  { "<F6>", function() picker.git_files({cwd='~/dotfiles'}) end, desc = "Picker: dotfiles" },
  { "<space>fh", function() picker.help() end, desc = "Picker: Help Pages" },
  { "<space>fH", function() picker.highlights() end, desc = "Picker: Highlights" },
	{ "<space>fA", function() picker.pickers() end, desc = "Picker: All sources" },
	-- stylua: ignore end
}

return M
