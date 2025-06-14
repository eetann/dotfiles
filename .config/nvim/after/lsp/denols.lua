vim.g.markdown_fenced_languages = {
	"ts=typescript",
}
---@type vim.lsp.Config
return {
	workspace_required = true,
	root_markers = { "deno.json", "deno.jsonc" },
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
