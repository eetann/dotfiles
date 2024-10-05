---@type lspconfig.Config
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
