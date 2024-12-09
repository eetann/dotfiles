return {
	"stevearc/conform.nvim",
	-- lazy loadingの推奨設定がある
	-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#lazy-loading-with-lazynvim
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	config = function()
		local js_formatters = { "biome", "prettierd", "prettier", stop_after_first = true }
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
				-- NOTE: svelteのformatはsvelteserverのやつを使う。
				-- LSPのFormatterは`lsp_fallback=true`をしたのでOK
				-- svelte = { { "svelteserver" } },
			},
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},
			},
		})
	end,
}
