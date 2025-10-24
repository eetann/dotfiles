---@module "lazy"
---@type LazyPluginSpec
return {
  "stevearc/conform.nvim",
  cond = not vim.g.vscode,
  -- lazy loadingの推奨設定がある
  -- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#lazy-loading-with-lazynvim
  event = { "BufWritePre" },
  cmd = { "ConformInfo", "Format", "FormatPrettierd" },
  config = function()
    local js_formatters =
      { "biome", "prettierd", "prettier", stop_after_first = true }
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        json = js_formatters,
        javascript = js_formatters,
        javascriptreact = js_formatters,
        typescript = js_formatters,
        typescriptreact = js_formatters,
        php = { "pint", "php_cs_fixer", stop_after_first = true },
        blade = { "blade-formatter" },
        -- まだpintではサポートされてないっぽい: https://github.com/laravel/pint/pull/256
        -- blade = { "pint","blade-formatter" },
        astro = js_formatters,
        cpp = { "clang-format" },
        -- NOTE: svelteのformatはsvelteserverのやつを使う。
        -- LSPのFormatterは`lsp_fallback=true`をしたのでOK
        -- svelte = { { "svelteserver" } },
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
        biome = {
          args = { "format", "--write", "--stdin-file-path", "$FILENAME" },
        },
      },
    })
    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line =
          vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({
        async = true,
        lsp_format = "fallback",
        range = range,
      })
    end, { range = true })
    vim.api.nvim_create_user_command("FormatPrettierd", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line =
          vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({
        async = true,
        range = range,
        formatters = { "prettierd" },
      })
    end, { range = true })
    vim.keymap.set({ "n", "x" }, "<Space>sF", "<Cmd>FormatPrettierd<CR>")
  end,
}
