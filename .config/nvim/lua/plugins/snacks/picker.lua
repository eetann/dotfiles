local picker = require("snacks.picker")

local function get_text()
	local visual = picker.util.visual()
	return visual and visual.text or ""
end

local my_vertical = { preset = "vertical", layout = { width = 0.9 } }

---gitを使って無ければfilesでpicker
---@param use_git_root boolean git_rootを使うかどうか。モノレポの個別プロジェクトならfalse
local function project_files(use_git_root)
	local text = get_text()

	local root = require("snacks.git").get_root()
	if root == nil then
		picker.files({ pattern = text, layout = my_vertical })
		return
	end
	if use_git_root then
		picker.git_files({
			untracked = true,
			pattern = text,
			layout = my_vertical,
		})
	else
		picker.git_files({
			untracked = true,
			pattern = text,
			cwd = vim.uv.cwd(),
			layout = my_vertical,
		})
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
				---@param item snacks.picker.finder.Item
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
	-- stylua: ignore end
	{
		"<space>fg",
		function()
			local text = get_text()
			picker.grep({
				hidden = true,
				on_show = function()
					vim.api.nvim_put({ text }, "c", true, true)
				end,
				layout = my_vertical,
			})
		end,
		mode = { "n", "x" },
		desc = "Picker: grep",
	},
	-- stylua: ignore start

  -- TODO検索
  ---@diagnostic disable-next-line: undefined-field
  { "<space>ft", function() picker.todo_comments() end, desc = "Picker: Todo" },
  ---@diagnostic disable-next-line: undefined-field
  { "<space>fT", function () picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Picker: Todo/Fix/Fixme" },

	-- vim固有
	-- stylua: ignore end
	{
		"<space>fh",
		function()
			picker.help({
				win = { input = { keys = {
					["<CR>"] = { "edit_vsplit", mode = { "i", "n" } },
				} } },
			})
		end,
		desc = "Picker: help pages",
	},
	-- stylua: ignore start
  { "<space>fH", function() picker.highlights() end, desc = "Picker: highlights" },
  { "<space>fk", function() picker.keymaps() end, desc = "Picker: keymaps" },
  { "<space>fm", function() picker.marks() end, desc = "Picker: marks" },

  -- LSP
  { "gr", function() picker.lsp_references() end, nowait = true, desc = "References" },

  -- pickerそのもの
  { "<space>fR", function() picker.resume() end, desc = "Picker: resume" },
	{ "<space>fA", function() picker.pickers() end, desc = "Picker: All sources" },
	-- stylua: ignore end

	-- カスタマイズの例
	{
		"<space>fz",
		function()
			picker({
				finder = function()
					local my_list = {
						{ quote = "選ばれるのは私よ！", thanks = "ありがとうなのだわ！" },
						{
							quote = "うるさいんですけどぉ〜",
							thanks = "別にありがとうとか思ってないんだからね！",
						},
						{ quote = "ちっす", thanks = "どうも" },
					}
					---@type snacks.picker.Item[]
					local items = {}
					for i, person in ipairs(my_list) do
						---@type snacks.picker.Item
						local item = {
							idx = i,
							score = 0,
							text = person.quote,
							thanks = person.thanks,
						}
						table.insert(items, item)
					end
					return items
				end,
				---@type snacks.picker.Action.spec
				confirm = function(the_picker, item)
					the_picker:close()
					vim.notify(item.thanks)
				end,
				format = "text",
				preview = "none",
				layout = { preset = "vscode" },
			})
		end,
	},
}

---@type snacks.picker.Config
M.config = {
	formatters = { file = { truncate = 200 } },
	layouts = {
		default = {
			layout = {
				width = 0.95,
			},
		},
	},
	win = {
		-- input window
		input = {
			keys = {
				-- select allを無効化
				["<c-a>"] = false,
				["<c-b>"] = false,
				["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
				["<c-f>"] = false,
				["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
				["<c-s>"] = false,
				["<c-x>"] = { "edit_split", mode = { "i", "n" } },
			},
		},
	},
}

return M
