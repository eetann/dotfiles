local util = require("lspconfig.util")

---@type lspconfig.Config|{}
return {
	root_dir = util.root_pattern("package.json", "node_modules"),
}
