---@type vim.lsp.Config
return {
	init_options = {
		provideFormatter = false,
	},
	settings = {
		css = {
			lint = {
				-- tailwind
				unknownAtRules = "ignore",
			},
		},
	},
}
