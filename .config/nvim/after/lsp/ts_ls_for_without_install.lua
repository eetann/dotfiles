---@type vim.lsp.Config
return {
  -- Bunでちょっとしたスクリプトを書くとき用。
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript" },
  workspace_required = false,
  settings = {
    diagnostics = {
      ignoredCodes = { 2307, 7016 },
    },
  },
}
