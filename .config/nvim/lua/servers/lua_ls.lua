---@type lspconfig.Config
return {
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		},
	},
}
