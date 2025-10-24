-- https://github.com/golang/tools/blob/v0.23.0/gopls/doc/vim.md#neovim-imports
-- fro ldo
_G.my_code_actions = function()
  vim.lsp.buf.code_action({
    apply = true,
    context = { diagnostics = {} },
    filter = function(action)
      return action.kind == "quickfix.biome.style.useImportType"
    end,
  })
  -- NOTE: buf_request_sync version
  --
  -- local params = vim.lsp.util.make_range_params()
  -- params.context = { diagnostics = {} }
  -- local kinds = { "quickfix.biome.style.useImportType" }
  -- local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
  -- -- vim.print(result)
  -- for _, res in pairs(result or {}) do
  -- 	for _, r in pairs(res.result or {}) do
  -- 		if table.in_value(kinds, r.kind) and r.edit then
  -- 			local enc = "utf-8"
  -- 			vim.lsp.util.apply_workspace_edit(r.edit, enc)
  -- 		end
  -- 	end
  -- end
end

vim.api.nvim_create_user_command("MyQuickfix", function()
  vim.diagnostic.setloclist()
  vim.cmd("sleep 500ms")
  vim.cmd("ldo call v:lua.my_code_actions()")
  vim.cmd("lclose")
end, {})
