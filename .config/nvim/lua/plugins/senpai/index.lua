---@module "lazy"
---@type LazyPluginSpec
return {
	-- "eetann/senpai.nvim",
	dir = "~/ghq/github.com/eetann/senpai.nvim",
	build = "bun install",
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
			common = {
				keymaps = {
					["gM"] = "show_mcp_tools",
					["gL"] = "show_log",
				},
			},
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
		mcp = {
			servers = {
				sequential = {
					command = "bunx",
					args = { "-y", "@modelcontextprotocol/server-sequential-thinking" },
				},
				mastra = {
					command = "bunx",
					args = { "-y", "@mastra/mcp-docs-server" },
				},
			},
		},
		debug = true,
	},
}
