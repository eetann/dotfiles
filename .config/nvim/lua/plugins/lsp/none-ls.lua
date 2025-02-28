return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "gbprod/none-ls-shellcheck.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local null_ls = require("null-ls")
		local redocly = {
			method = null_ls.methods.DIAGNOSTICS,
			filetypes = { "yaml", "json" },

			generator = null_ls.generator({
				ignore_stderr = true,
				command = "pnpm",
				args = { "redocly", "lint", "--format", "checkstyle" },
				format = "line",
				on_output = require("null-ls.helpers").diagnostics.from_patterns({
					{
						-- Examples:
						-- <error line="129" column="5" severity="error" message="Operation object should contain `summary` field." source="operation-summary" />
						-- <error line="20" column="5" severity="error" message="Operation object should contain `summary` field." source="operation-summary" />
						-- <error line="2" column="1" severity="warning" message="Info object should contain `license` field." source="info-license" />
						pattern = [[<error line="(%d+)" column="(%d+)" severity="(%w+)" message="(.+)" source="(.+)" />]],
						groups = { "row", "col", "severity", "message", "source" },
						overrides = { -- We want to list the errors as redocly as source, so we know where they come from
							diagnostic = { source = "redocly" },
						},
					},
				}),
			}),
		}

		local sources = {
			redocly,
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
