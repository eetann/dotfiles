if vim.b.my_plugin_typescript ~= nil then
  return
end
vim.b.my_plugin_typescript = true

vim.api.nvim_create_user_command("TSLSWithoutInstallEnable", function()
  vim.b.bun_script = true
  vim.cmd("LspStop ts_ls")
  vim.lsp.enable("ts_ls_for_without_install")
  vim.cmd("LspStart ts_ls_for_without_install")
end, {})

vim.api.nvim_create_user_command("TSLSWithoutInstallDisable", function()
  vim.b.bun_script = false
  vim.cmd("LspStop ts_ls_for_without_install")
  vim.cmd("LspStart ts_ls")
end, {})
