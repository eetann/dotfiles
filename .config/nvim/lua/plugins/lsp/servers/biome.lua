local binary_name = "biome"

---@type lspconfig.Config
return {
	cmd = { "biome", "lsp-proxy" },
	on_new_config = function(new_config)
		local local_binary = vim.fn.fnamemodify("./node_modules/.bin/" .. binary_name, ":p")
		new_config.cmd = { local_binary, "lsp-proxy" }
	end,
}
