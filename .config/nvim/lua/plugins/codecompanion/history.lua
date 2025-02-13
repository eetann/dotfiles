-- ref: https://gist.github.com/itsfrank/942780f88472a14c9cbb3169012a3328
-- create a folder to store our chats
local Path = require("plenary.path")
local data_path = vim.fn.stdpath("data")
local save_folder = Path:new(data_path, "cc_saves")
if not save_folder:exists() then
	save_folder:mkdir({ parents = true })
end

vim.api.nvim_create_user_command("CodeCompanionLoad", function()
	local function start_picker()
		require("snacks.picker").files({
			prompt_title = "Saved CodeCompanion Chats",
			cwd = save_folder:absolute(),
			win = {
				input = {
					keys = {
						["dd"] = { "delete_file", mode = { "n", "i" } },
					},
				},
			},
			actions = {
				delete_file = function(the_picker)
					the_picker.preview:reset()
					for _, item in ipairs(the_picker:selected({ fallback = true })) do
						if item.file then
							os.remove(item.cwd .. "/" .. item.file)
						end
					end
					the_picker.list:set_selected()
					the_picker.list:set_target()
					the_picker:find()
				end,
			},
		})
	end
	start_picker()
end, {})

-- save current chat, `CodeCompanionSave foo bar baz` will save as 'foo-bar-baz.md'
vim.api.nvim_create_user_command("CodeCompanionSave", function(opts)
	local codecompanion = require("codecompanion")
	local success, chat = pcall(function()
		return codecompanion.buf_get_chat(0)
	end)
	if not success or chat == nil then
		vim.notify("CodeCompanionSave should only be called from CodeCompanion chat buffers", vim.log.levels.ERROR)
		return
	end
	if #opts.fargs == 0 then
		vim.notify("CodeCompanionSave requires at least 1 arg to make a file name", vim.log.levels.ERROR)
	end
	local save_name = table.concat(opts.fargs, "-") .. ".md"
	local save_path = Path:new(save_folder, save_name)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	save_path:write(table.concat(lines, "\n"), "w")
end, { nargs = "*" })
