local lspconfig = require("lspconfig")
local function server_register(server_name)
	local opts = {}
	local success, req_opts = pcall(require, "plugins.lsp.servers." .. server_name)
	if success then
		opts = req_opts
	end
	opts.capabilities = require("blink.cmp").get_lsp_capabilities(opts.capabilities)
	-- .config/nvim/lua/lsp/[server_name].lua
	lspconfig[server_name].setup(opts)
end

-- angular-language-server
-- cssls
-- nil
-- phpactor
-- php-cs-fixer
-- stylua
-- typescript-language-server
require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup_handlers({ server_register })

-- local other_lsp = { "biome", "eslint", "jsonls" }
local other_lsp = {
	-- list
	"biome",
	-- "eslint",
	"jsonls",
	-- "laravel-language-server",
	"markdown-language-server",
}
for _, server_name in pairs(other_lsp) do
	server_register(server_name)
end
