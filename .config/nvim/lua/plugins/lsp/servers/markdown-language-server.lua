local util = require("lspconfig.util")
local configs = require("lspconfig.configs")

-- ここにこのリポジトリのパスを書いておく
local server_path = vim.fn.expand("~/ghq/github.com/eetann/markdown-language-server/")

configs["markdown-language-server"] = {
	default_config = {
		cmd = { "node", server_path .. "packages/server/bin/markdown-language-server.cjs", "--stdio" },
		filetypes = { "markdown" },
		root_dir = util.root_pattern("mdconfig.json5"),
		settings = {},
	},
}

---@type lspconfig.Config|{}
return {}
