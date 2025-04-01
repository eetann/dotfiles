---@module "lazy"
---@type LazyPluginSpec
return {
	-- "eetann/senpai.nvim",
	dir = "~/ghq/github.com/eetann/senpai.nvim",
	keys = {
		{ "<space>ss", "<Cmd>Senpai toggleChat<CR>" },
	},
	cmd = { "Senpai" },
	ft = "gitcommit",
	---@module "senpai"
	---@type senpai.Config
	opts = {
		providers = {
			default = "openrouter",
		},
		chat = {
			input_area = {
				keymaps = {
					["<CR>"] = false,
					["<CR><CR>"] = "submit",
				},
			},
		},
		prompt_launchers = {
			["Blog composition"] = require("plugins.senpai.launcher_blog_composition"),
			["test message"] = {
				user = "test message. Hello!",
				priority = 90,
			},
		},
	},
}
