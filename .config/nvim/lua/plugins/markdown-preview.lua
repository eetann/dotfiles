---@module "lazy"
---@type LazyPluginSpec
return {
  "selimacerbas/markdown-preview.nvim",
  dependencies = { "selimacerbas/live-server.nvim" },
  ft = { "markdown", "pu", "plantuml" },
  opts = {},
}
