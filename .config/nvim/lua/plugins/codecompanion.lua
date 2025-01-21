return {
	"olimorris/codecompanion.nvim",
	cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat", "CodeCompanionCmd" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim",
		{ "zbirenbaum/copilot.lua", opts = {} },
		{
			"stevearc/dressing.nvim",
			opts = {
				input = {
					enabled = false,
				},
			},
		},
	},
	init = function()
		vim.cmd([[cab cc CodeCompanion]])
		vim.cmd([[cab ccc CodeCompanionChat]])
	end,
	config = function()
		require("codecompanion").setup({
			strategies = {
				chat = {
					adapter = "copilot",
					keymaps = {
						send = {
							modes = {
								n = { "<CR><CR>" },
							},
						},
					},
				},
				inline = {
					adapter = "copilot",
				},
				agent = {
					adapter = "copilot",
				},
			},
			actions = {
				{
					name = "Translate",
					description = "LSP & Translate",
					opts = {
						modes = { "v" },
					},
					callback = function(context)
						local agent = require("codecompanion.workflow")
						return agent
							.new({
								context = context,
								strategy = "chat",
							})
							:workflow({
								{
									role = "system",
									start = true,
									content = [[You are an expert coder and helpful assistant who can help debug code diagnostics, such as warning and error messages. When appropriate, give solutions with code snippets as fenced codeblocks with a language identifier to enable syntax highlighting.]],
								},
								{
									role = "${user}",
									start = true,
									content = function(context)
										local diagnostics = require("codecompanion.helpers.actions").get_diagnostics(
											context.start_line,
											context.end_line,
											context.bufnr
										)

										local concatenated_diagnostics = ""
										for i, diagnostic in ipairs(diagnostics) do
											concatenated_diagnostics = concatenated_diagnostics
												.. i
												.. ". Issue "
												.. i
												.. "\n  - Location: Line "
												.. diagnostic.line_number
												.. "\n  - Severity: "
												.. diagnostic.severity
												.. "\n  - Message: "
												.. diagnostic.message
												.. "\n"
										end

										return "The programming language is "
											.. context.filetype
											.. ". This is a list of the diagnostic messages:\n\n"
											.. concatenated_diagnostics
									end,
								},
								-- {
								-- 	role = "${user}",
								-- 	contains_code = true,
								-- 	start = true,
								-- 	content = function(context)
								-- 		return "This is the code, for context:\n\n"
								-- 			.. "```"
								-- 			.. context.filetype
								-- 			.. "\n"
								-- 			.. require("codecompanion.helpers.actions").get_code(
								-- 				context.start_line,
								-- 				context.end_line,
								-- 				{ show_line_numbers = true }
								-- 			)
								-- 			.. "\n```\n\n"
								-- 	end,
								-- },
								-- {
								-- 	role = "${user}",
								-- 	content = "回答を日本語に翻訳してください。",
								-- 	auto_submit = true,
								-- },
							})
					end,
				},
			},
		})

		-- ref: https://gist.github.com/itsfrank/942780f88472a14c9cbb3169012a3328
		-- create a folder to store our chats
		local Path = require("plenary.path")
		local data_path = vim.fn.stdpath("data")
		local save_folder = Path:new(data_path, "cc_saves")
		if not save_folder:exists() then
			save_folder:mkdir({ parents = true })
		end

		-- telescope picker for our saved chats
		vim.api.nvim_create_user_command("CodeCompanionLoad", function()
			local t_builtin = require("telescope.builtin")
			local t_actions = require("telescope.actions")
			local t_action_state = require("telescope.actions.state")

			local function start_picker()
				t_builtin.find_files({
					prompt_title = "Saved CodeCompanion Chats | <c-d>: delete",
					cwd = save_folder:absolute(),
					-- attach_mappings = function(_, map)
					-- 	map("i", "<c-d>", function(prompt_bufnr)
					-- 		local selection = t_action_state.get_selected_entry()
					-- 		local filepath = selection.path or selection.filename
					-- 		os.remove(filepath)
					-- 		t_actions.close(prompt_bufnr)
					-- 		start_picker()
					-- 	end)
					-- 	return true
					-- end,
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
				vim.notify(
					"CodeCompanionSave should only be called from CodeCompanion chat buffers",
					vim.log.levels.ERROR
				)
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
	end,
}
