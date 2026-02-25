---@type vim.lsp.Config
return {
  cmd = { "node_modules/.bin/oxfmt", "--lsp" },
  root_markers = { ".oxfmtrc.json", ".oxfmtrc.jsonc" },
}
