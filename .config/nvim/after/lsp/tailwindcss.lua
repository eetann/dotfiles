---@type vim.lsp.Config
return {
	settings = {
		tailwindCSS = {
			experimental = {
				classRegex = {
					{ "tv\\((([^()]*|\\([^()]*\\))*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
				},
			},
		},
	},
}
