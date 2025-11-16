-- angular-language-server
-- python-lsp-server # pylsp
-- cssls
-- nil_ls
-- phpactor
-- php-cs-fixer
-- stylua
-- typescript-language-server
require("mason").setup()
require("mason-lspconfig").setup()

local other_lsp = {
  -- list
  -- "biome",  -- disabled by default
  "eslint",
  "jsonls",
  -- "laravel-language-server", -- disable
  "markdown-language-server",
  -- "ts_ls_for_without_install", -- disabled by default
}
for _, server_name in pairs(other_lsp) do
  vim.lsp.enable(server_name)
end

if vim.fn.filereadable("node_modules/.bin/biome") == 1 then
  vim.lsp.enable("biome")
end

if os.getenv("TS_LS_GLOBAL") == "1" then
  vim.lsp.disable("ts_ls")
  vim.lsp.enable("ts_old_project_ls")
end
