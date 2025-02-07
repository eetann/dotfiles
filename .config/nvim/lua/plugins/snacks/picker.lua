local picker = require("snacks.picker")

local function getText()
	local visual = picker.util.visual()
	return visual and visual.text or ""
end

---gitを使って無ければfilesでpicker
---@param use_git_root boolean git_rootを使うかどうか。モノレポの個別プロジェクトならfalse
local function project_files(use_git_root)
	local text = getText()

	local root = require("snacks.git").get_root()
	if root == nil then
		picker.files({ pattern = text })
		return
	end
	if use_git_root then
		picker.git_files({ pattern = text })
	else
		picker.git_files({ pattern = text, cwd = vim.uv.cwd() })
	end
end

local M = {}
---@module "lazy"
---@type LazyKeysSpec[]
M.keys = {
  -- stylua: ignore start
	{ "<space>fb", function() picker.buffers() end, desc = "Picker: Buffers" },
  { "<space>fd", function() picker.diagnostics() end, desc = "Picker: Diagnostics" },

  -- file
  { "<space>ff", function() project_files(false) end, mode = { "n", "x" }, desc = "Picker files: モノレポでプロジェクト毎" },
  { "<space>fF", function() project_files(true) end, mode = { "n", "x" }, desc = "Picker files: モノレポでプロジェクト全体" },
	-- stylua: ignore end
	{
		"<space>fc",
		function()
			picker({
				finder = "proc",
				cmd = "find",
				args = { vim.fn.expand("%:h"), "-maxdepth", "1", "-type", "f", "-not", "-name", vim.fn.expand("%:t") },
				transform = function(item)
					item.file = item.text
				end,
			})
		end,
		mode = { "n" },
		desc = "Picker files: 同階層のみ",
	},
	{
		"<space>fC",
		function()
			picker({
				finder = "proc",
				cmd = "find",
				args = { vim.fn.expand("%:h"), "-type", "f", "-not", "-name", vim.fn.expand("%:t") },
				transform = function(item)
					item.file = item.text
				end,
				formatters = { file = { truncate = 200 } },
			})
		end,
		mode = { "n" },
		desc = "Picker files: 同階層以下",
	},
	-- stylua: ignore start
  { "<F6>", function() picker.git_files({ cwd = '~/dotfiles' }) end, desc = "Picker files: dotfiles" },
  { "<space>fr", function() picker.recent({ filter = { cwd = true } }) end, desc = "Picker: recent" },

  -- grep
  { "<space>fg", function() picker.grep({ pattern = getText() }) end, mode = { "n", "x" }, desc = "Picker: grep" },
  { "<space>fg", function() picker.grep({ pattern = getText(), regex = false }) end, mode = { "n", "x" }, desc = "Picker: grep" },

  -- TODO検索
  ---@diagnostic disable-next-line: undefined-field
  { "<space>ft", function() picker.todo_comments() end, desc = "Picker: Todo" },
  ---@diagnostic disable-next-line: undefined-field
  { "<space>fT", function () picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Picker: Todo/Fix/Fixme" },

  -- vim固有
  { "<space>fh", function() picker.help() end, desc = "Picker: help pages" },
  { "<space>fH", function() picker.highlights() end, desc = "Picker: highlights" },

  -- pickerそのもの
  { "<space>fR", function() picker.resume() end, desc = "Picker: resume" },
	{ "<space>fA", function() picker.pickers() end, desc = "Picker: All sources" },
	-- stylua: ignore end
}

return M
