return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("plugins.lsp.linters.textlint")
		require("lint").linters_by_ft = {
			markdown = { "textlint" },
			mdx = { "textlint" },
			sh = { "shellcheck" },
		}

		vim.api.nvim_create_autocmd({ "BufReadPost", "InsertLeave" }, {
			callback = function()
				vim.defer_fn(require("lint").try_lint, 1)
			end,
		})
	end,
}
