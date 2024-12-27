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
	config = function()
		require("codecompanion").setup({
			strategies = {
				chat = {
					adapter = "copilot",
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

		-- Expand 'cc' into 'CodeCompanion' in the command line
		vim.cmd([[cab cc CodeCompanion]])
	end,
}
