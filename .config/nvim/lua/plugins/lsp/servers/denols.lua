local util = require("lspconfig.util")
vim.g.markdown_fenced_languages = {
	"ts=typescript",
}
---@type lspconfig.Config
---@diagnostic disable-next-line: missing-fields
return {
	root_dir = util.root_pattern("deno.jsonc", "deno.json"),
	single_file_support = false,
	init_options = {
		lint = true,
		unstable = false,
		suggest = {
			imports = {
				hosts = {
					["https://deno.land"] = true,
				},
			},
		},
	},
}
