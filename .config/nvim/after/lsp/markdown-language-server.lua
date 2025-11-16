-- Custom markdown-language-server configuration
local server_path =
  vim.fn.expand("~/ghq/github.com/eetann/markdown-language-server")

---@type vim.lsp.Config
return {
  cmd = {
    "node",
    server_path .. "/packages/server/bin/markdown-language-server.cjs",
    "--stdio",
  },
  filetypes = { "markdown" },
  root_markers = { "mdconfig.json5" },
  settings = {},
}
