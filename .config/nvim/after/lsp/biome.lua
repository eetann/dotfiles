---@type vim.lsp.Config
return {
  cmd = { "node_modules/.bin/biome", "lsp-proxy" },
  root_markers = { "biome.json", "biome.jsonc" },
}
