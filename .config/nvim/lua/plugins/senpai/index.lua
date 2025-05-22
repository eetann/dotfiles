---@module "lazy"
---@type LazyPluginSpec
return {
	-- "eetann/senpai.nvim",
	dir = "~/ghq/github.com/eetann/senpai.nvim",
	build = "bun install --frozen-lockfile",
	cond = not vim.g.vscode,
	keys = {
		{ "<space>ss", "<Cmd>Senpai toggleChat<CR>" },
		{ "<space>sl", "<Cmd>Senpai promptLauncher<CR>" },
		{ "<space>sv", "<Cmd>Senpai transferToChat<CR>", mode = "v" },
	},
	cmd = { "Senpai" },
	ft = "gitcommit",
	---@module "senpai"
	---@type senpai.Config
	opts = {
		providers = {
			default = "openrouter",
			openrouter = { model_id = "openai/gpt-4.1" },
		},
		chat = {
			system_prompt = "回答は必ずフレンドリーな快男児の先輩として日本語で答えてください",
			common = {
				keymaps = {
					["gL"] = "show_internal_log",
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
				-- daisyUi = {
				-- 	command = "npx",
				-- 	args = {
				-- 		"-y",
				-- 		"sitemcp",
				-- 		"https://daisyui.com",
				-- 		"-m",
				-- 		"/components/**",
				-- 	},
				-- },
			},
		},
		debug = true,
	},
}
