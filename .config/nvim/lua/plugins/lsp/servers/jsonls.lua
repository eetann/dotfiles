---@type lspconfig.Config
---@diagnostic disable-next-line: missing-fields
return {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
}
