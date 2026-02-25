---@type vim.lsp.Config
return {
  cmd = { "node_modules/.bin/oxlint", "--lsp" },
  root_markers = { ".oxlintrc.json", ".oxlintrc.jsonc" },
}
