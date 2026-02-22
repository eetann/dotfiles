if vim.b.my_plugin_typescript ~= nil then
  return
end
vim.b.my_plugin_typescript = true

-- Denoのシェバンを検出したらts_lsを停止
local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
if first_line:match("^#!.*deno") or first_line:match("^//.*deno") then
  vim.api.nvim_create_autocmd("LspAttach", {
    buffer = 0,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == "ts_ls" then
        vim.cmd("LspStop ts_ls")
        vim.lsp.enable("denols")
        vim.cmd("LspStart denols")
        return true -- autocmd削除
      end
    end,
  })
end

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
