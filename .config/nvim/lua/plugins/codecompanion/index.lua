return {
	"olimorris/codecompanion.nvim",
	cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionLoad" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		{ "zbirenbaum/copilot.lua", opts = {} },
	},
	init = function()
		vim.cmd([[cab cc CodeCompanion]])
		vim.cmd([[cab ccc CodeCompanionChat]])
	end,
	config = function()
		require("codecompanion").setup({
			language = "Japanese",
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
			prompt_library = {
				["Generate English Commit Message"] = require("plugins.codecompanion.prompt.commit-message-english"),
				["Generate Japanese Commit Message"] = require("plugins.codecompanion.prompt.commit-message-japanese"),
			},
		})
		require("plugins.codecompanion.history")
		vim.api.nvim_create_autocmd({ "FileType" }, {
			group = "my_nvim_rc",
			pattern = "codecompanion",
			callback = function()
				vim.keymap.set("n", "qq", "<Cmd>:quit<CR>", { buffer = true, silent = true })
			end,
		})
	end,
}
