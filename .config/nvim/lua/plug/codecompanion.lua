require("codecompanion").setup({
	ollama = require("codecompanion.adapters").use("ollama", {
		schema = {
			model = {
				default = "codellama:13b",
			},
		},
	}),
	strategies = {
		chat = {
			adapter = "ollama",
		},
		inline = {
			adapter = "ollama",
		},
		agent = {
			adapter = "ollama",
		},
	},
	-- default_prompts = {
	-- 	["Explain LSP Diagnostics"] = {
	-- 		strategy = "chat",
	-- 		description = "Explain the LSP diagnostics for the selected code",
	-- 		opts = {
	-- 			index = 8,
	-- 			default_prompt = true,
	-- 			mapping = "<LocalLeader>cl",
	-- 			modes = { "v" },
	-- 			slash_cmd = "lsp",
	-- 			auto_submit = true,
	-- 			user_prompt = false,
	-- 			stop_context_insertion = true,
	-- 		},
	-- 		prompts = {
	-- 			{
	-- 				role = "system",
	-- 				content = [[あなたは専門的なコーダーであり、警告やエラーメッセージなどのコード診断のデバッグを助けることができる親切なアシスタントです。適切な場合は、シンタックスハイライトを有効にするために言語識別子をフェンスで囲んだコードブロックとしてコードスニペットで解決策を与えます。日本語で回答してください。]],
	-- 			},
	-- 			{
	-- 				role = "${user}",
	-- 				content = function(context)
	-- 					local diagnostics = require("codecompanion.helpers.actions").get_diagnostics(
	-- 						context.start_line,
	-- 						context.end_line,
	-- 						context.bufnr
	-- 					)
	--
	-- 					local concatenated_diagnostics = ""
	-- 					for i, diagnostic in ipairs(diagnostics) do
	-- 						concatenated_diagnostics = concatenated_diagnostics
	-- 							.. i
	-- 							.. ". Issue "
	-- 							.. i
	-- 							.. "\n  - Location: Line "
	-- 							.. diagnostic.line_number
	-- 							.. "\n  - Severity: "
	-- 							.. diagnostic.severity
	-- 							.. "\n  - Message: "
	-- 							.. diagnostic.message
	-- 							.. "\n"
	-- 					end
	--
	-- 					return "プログラミング言語は"
	-- 						.. context.filetype
	-- 						.. "です。diagnosticの一覧は次のとおりです。:\n\n"
	-- 						.. concatenated_diagnostics
	-- 				end,
	-- 			},
	-- 			{
	-- 				role = "${user}",
	-- 				contains_code = true,
	-- 				content = function(context)
	-- 					return "関連するコードは次のとおりです。:\n\n"
	-- 						.. "```"
	-- 						.. context.filetype
	-- 						.. "\n"
	-- 						.. require("codecompanion.helpers.actions").get_code(
	-- 							context.start_line,
	-- 							context.end_line,
	-- 							{ show_line_numbers = true }
	-- 						)
	-- 						.. "\n```\n\n"
	-- 				end,
	-- 			},
	-- 		},
	-- 	},
	-- },
})

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
