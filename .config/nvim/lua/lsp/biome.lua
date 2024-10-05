local util = require("lspconfig.util")

---@type lspconfig.Config
return {
	cmd = { "biome", "lsp-proxy" },
	on_new_config = function(new_config)
		local pnpm = util.root_pattern("pnpm-lock.yml", "pnpm-lock.yaml")(vim.api.nvim_buf_get_name(0))
		local cmd = { "npx", "biome", "lsp-proxy" }
		if pnpm then
			cmd = { "pnpm", "biome", "lsp-proxy" }
		end
		new_config.cmd = cmd
	end,
}
