-- local util = require("lspconfig.util")

---@type lspconfig.Config|{}
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
