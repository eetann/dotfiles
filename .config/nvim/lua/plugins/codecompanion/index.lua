---@module "lazy"
---@type LazyPluginSpec
return {
	"olimorris/codecompanion.nvim",
	cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionLoad" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		{ import = "plugins.copilot" },
	},
	keys = {
		{ "<Space>cc", "<Cmd>CodeCompanionChat Toggle<CR>", mode = { "n" } },
		{ "<Space>cc", "<Cmd>CodeCompanionChat<CR>", mode = { "v" } },
		{ "<Space>ca", "<Cmd>CodeCompanionActions<CR>", mode = { "n", "x" } },
	},
	init = function()
		vim.cmd([[cab cc CodeCompanion]])
		vim.cmd([[cab ccc CodeCompanionChat]])
		-- vim.g.codecompanion_auto_tool_mode = true
	end,
	config = function()
		local my_adapter = vim.env.OPENAI_API_KEY and "openai" or "copilot"
		require("codecompanion").setup({
			opts = {
				language = "Japanese",
			},
			adapters = {
				openai = function()
					return require("codecompanion.adapters").extend("openai", {
						env = { api_key = vim.env.OPENAI_API_KEY },
					})
				end,
			},
			strategies = {
				chat = {
					adapter = my_adapter,
					keymaps = {
						send = {
							modes = {
								n = { "<CR><CR>" },
							},
						},
					},
					slash_commands = {
						["file"] = {
							-- Location to the slash command in CodeCompanion
							callback = "strategies.chat.slash_commands.file",
							description = "Select a file using Snacks",
							opts = {
								provider = "snacks",
								contains_code = true,
							},
						},
					},
				},
				inline = {
					adapter = my_adapter,
				},
				agent = {
					adapter = my_adapter,
				},
			},
			prompt_library = {
				["Add memo tag"] = require("plugins.codecompanion.prompt.memo-tag"),
				["Generate English Commit Message"] = require("plugins.codecompanion.prompt.commit-message-english"),
				["Generate Japanese Commit Message"] = require("plugins.codecompanion.prompt.commit-message-japanese"),
			},
		})
		require("plugins.codecompanion.history")
		vim.api.nvim_create_autocmd({ "FileType" }, {
			group = "my_nvim_rc",
			pattern = "codecompanion",
			callback = function()
				vim.keymap.set("n", "qq", "<Cmd>quit<CR>", { buffer = true, silent = true })
			end,
		})
	end,
}
