return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("plugins.lsp.linters.textlint")
		require("plugins.lsp.linters.redocly")
		require("lint").linters_by_ft = {
			markdown = { "textlint" },
			yaml = { "redocly" },
			mdx = { "textlint" },
			sh = { "shellcheck" },
		}

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
			callback = function()
				vim.defer_fn(require("lint").try_lint, 1)
			end,
		})
	end,
}
