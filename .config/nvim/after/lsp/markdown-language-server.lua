-- Custom markdown-language-server configuration
local server_path =
  vim.fn.expand("~/ghq/github.com/eetann/markdown-language-server/")

return {
  cmd = { "node" },
  arg = {
    server_path .. "packages/server/bin/markdown-language-server.cjs",
    "--stdio",
  },
  root_markers = { "mdconfig.json5" },
  settings = {},
}
