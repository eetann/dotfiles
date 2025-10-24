vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

-- https://github.com/golang/tools/blob/v0.23.0/gopls/doc/vim.md#neovim-imports
-- for ldo
_G.run_code_action_only = function(only)
  vim.lsp.buf.code_action({
    context = {
      only = { only },
      diagnostics = {},
    },
    apply = true,
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = "my_nvim_rc",
  callback = function()
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args)
        if
          vim.g.disable_autoformat
          or vim.b[args.buf].disable_autoformat
          or os.getenv("FORMATTER_DISABLE") == "1"
        then
          return
        end
        local server_actions = {
          biome = { "source.organizeImports.biome" },
          gopls = { "source.organizeImports.gopls" },
        }
        local shouldSleep = false
        for _, buf_client in pairs(vim.lsp.get_clients({ bufnr = args.bufnr })) do
          local actions = server_actions[buf_client.name] or {}
          for _, action in pairs(actions or {}) do
            run_code_action_only(action)
            if shouldSleep then
              vim.api.nvim_command("sleep 50ms")
            end
            shouldSleep = true
          end
        end
        require("conform").format({
          bufnr = args.buf,
          lsp_fallback = true,
          filter = function(c)
            return c.name ~= "ts_ls"
          end,
        })
      end,
    })
  end,
})
