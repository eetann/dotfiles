---@type vim.lsp.Config
return {
  cmd = { "node_modules/.bin/oxc_language_server" },
  root_markers = { ".oxlintrc.json", ".oxlintrc.jsonc" },
}
