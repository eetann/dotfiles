---@type vim.lsp.Config
return {
  cmd = function(root_dir)
    local cmd = root_dir .. "/node_modules/.bin/oxc_language_server"
    if vim.fn.executable(cmd) == 1 then
      return { cmd }
    end
    ---@diagnostic disable-next-line: return-type-mismatch
    return nil
  end,
  root_markers = { ".oxlintrc.json", ".oxlintrc.jsonc" },
}
