local util = require("lspconfig.util")
local configs = require("lspconfig.configs")

local server_path = vim.fn.expand("~/ghq/github.com/eetann/laravel-lsp/")

configs["laravel-lsp"] = {
	default_config = {
		cmd = { "node", server_path .. "dist/server.js", "--stdio" },
		filetypes = { "blade", "php" },
		-- TODO: 後で修正
		root_dir = util.root_pattern("composer.json", "package.json"),
		settings = {},
	},
}

---@type lspconfig.Config
return {}
