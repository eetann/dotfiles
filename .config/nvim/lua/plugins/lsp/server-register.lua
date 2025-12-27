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
  "biome",
  "eslint",
  "oxc_lsp",
  "jsonls",
  -- "laravel-language-server", -- disable
  -- "markdown-language-server", -- disabled by default
  -- "ts_ls_for_without_install", -- disabled by default
}
for _, server_name in pairs(other_lsp) do
  vim.lsp.enable(server_name)
end

if os.getenv("TS_LS_GLOBAL") == "1" then
  vim.lsp.disable("ts_ls")
  vim.lsp.enable("ts_old_project_ls")
end
