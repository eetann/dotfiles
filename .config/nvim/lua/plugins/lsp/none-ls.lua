return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "gbprod/none-ls-shellcheck.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local null_ls = require("null-ls")

		local sources = {
			null_ls.builtins.diagnostics.textlint.with({
				filetypes = { "markdown", "mdx" },
				condition = function(utils)
					local is_mdn = utils.root_matches("translated%-content")
					local is_not_dotfiles = not utils.root_matches("dotfiles")
					return is_mdn
						or (
							is_not_dotfiles
							and utils.root_has_file({
								".textlintrc",
								".textlintrc.js",
								".textlintrc.json",
								".textlintrc.yml",
								".textlintrc.yaml",
							})
						)
				end,
				cwd = function(params)
					local is_mdn = params.root:find("translated%-content")
					return is_mdn and vim.fn.expand("~/ghq/github.com/mozilla-japan/translation/MDN/textlint")
				end,
			}),
			null_ls.builtins.formatting.stylua,
		}
		require("null-ls").register(require("none-ls-shellcheck.diagnostics"))
		require("null-ls").register(require("none-ls-shellcheck.code_actions"))
		null_ls.setup({
			sources = sources,
			should_attach = function(bufnr)
				return not vim.api.nvim_buf_get_name(bufnr):match("gen%.nvim")
			end,
		})
	end,
}
