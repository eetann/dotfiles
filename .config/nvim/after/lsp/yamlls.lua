---@type vim.lsp.Config
return {
  settings = {
    yaml = {
      schemas = {
        ["https://spec.openapis.org/oas/3.1/schema/2022-10-07"] = "openapi/*.{yaml,yml}",
      },
    },
  },
}
