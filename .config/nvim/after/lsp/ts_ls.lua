---@type vim.lsp.Config
return {
  cmd = { "typescript-language-server", "--stdio" },
  root_markers = { "package.json" },
  workspace_required = true,
}
