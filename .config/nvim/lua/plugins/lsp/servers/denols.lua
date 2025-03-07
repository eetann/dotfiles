local util = require("lspconfig.util")
vim.g.markdown_fenced_languages = {
	"ts=typescript",
}
---@type lspconfig.Config
---@diagnostic disable-next-line: missing-fields
return {
	root_dir = util.root_pattern("deno.jsonc", "deno.json"),
	init_options = {
		lint = true,
		suggest = {
			imports = {
				hosts = {
					["https://deno.land"] = true,
				},
			},
		},
	},
}
