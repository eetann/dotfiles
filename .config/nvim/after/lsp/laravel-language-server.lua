-- Custom laravel-language-server configuration
local server_path = vim.fn.expand("~/ghq/github.com/eetann/laravel-language-server/")

return {
	cmd = { "node" },
	arg = { server_path .. "packages/language-server/bin/laravel-language-server.js", "--stdio" },
	filetypes = { "blade", "php" },
	root_markers = { "composer.json" },
	settings = {},
}
