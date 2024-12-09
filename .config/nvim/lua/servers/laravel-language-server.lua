local util = require("lspconfig.util")
local configs = require("lspconfig.configs")

local server_path = vim.fn.expand("~/ghq/github.com/eetann/laravel-language-server/")

configs["laravel-language-server"] = {
	default_config = {
		cmd = { "node", server_path .. "packages/language-server/bin/laravel-language-server.js", "--stdio" },
		filetypes = { "blade", "php" },
		root_dir = util.root_pattern("composer.json"),
		settings = {},
	},
}

---@type lspconfig.Config
return {}
