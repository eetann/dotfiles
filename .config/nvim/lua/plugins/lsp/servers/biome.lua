local util = require("lspconfig.util")
local binary_name = "biome"

---@type lspconfig.Config
return {
	cmd = { "biome", "lsp-proxy" },
	on_new_config = function(new_config)
		local path = vim.api.nvim_buf_get_name(0)
		if util.root_pattern("bun.lock")(path) then
			new_config.cmd = { "bunx", "biome", "lsp-proxy" }
		elseif util.root_pattern("pnpm-lock.yml", "pnpm-lock.yaml")(path) then
			new_config.cmd = { "pnpm", "biome", "lsp-proxy" }
		else
			new_config.cmd = { "npx", "biome", "lsp-proxy" }
		end
	end,
}
