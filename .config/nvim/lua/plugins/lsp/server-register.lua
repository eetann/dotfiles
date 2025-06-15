-- angular-language-server
-- cssls
-- nil
-- phpactor
-- php-cs-fixer
-- stylua
-- typescript-language-server
require("mason").setup()
require("mason-lspconfig").setup()

-- local other_lsp = { "biome", "eslint", "jsonls" }
local other_lsp = {
	-- list
	"biome",
	-- "eslint", // disable
	"jsonls",
	-- "laravel-language-server", // disable
	"markdown-language-server",
}
for _, server_name in pairs(other_lsp) do
	vim.lsp.enable(server_name)
end

if os.getenv("TS_LS_GLOBAL") == "1" then
	vim.lsp.enable("ts_old_project_ls")
end
