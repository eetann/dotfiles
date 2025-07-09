return {
	"mfussenegger/nvim-lint",
	cond = not vim.g.vscode,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("plugins.lsp.linters.textlint")
		require("plugins.lsp.linters.redocly")
		require("lint").linters_by_ft = {
			-- markdown = { "textlint" },
			yaml = { "redocly" },
			-- mdx = { "textlint" },
			sh = { "shellcheck" },
		}

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
			pattern = { "*.mdx" },
			callback = function()
				vim.defer_fn(require("lint").try_lint, 1)
				vim.defer_fn(function()
					if
						vim.fn.getcwd() == vim.fn.expand("~/ghq/github.com/eetann/cyber-blog")
						and vim.fn.expand("%:h"):match("src/content/post")
					then
						require("lint").try_lint("textlint")
					end
				end, 1)
			end,
		})
	end,
}
