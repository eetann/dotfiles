return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufNewFile", "BufRead" },
		config = function()
			local function is_file_too_large(bufnr)
				local size = vim.api.nvim_buf_line_count(bufnr)
				return size > 10000
			end
			local function is_minified_file(bufnr)
				-- is likely minified if one of the first 5 lines is longer than 1000 characters
				for i = 0, 5 do
					local lines = vim.api.nvim_buf_get_lines(bufnr, i, i + 1, false)
					if #lines == 0 then
						return false
					end
					if #lines[1] > 300 then
						return true
					end
				end
				return false
			end

			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"astro",
					"bash",
					"c",
					"cpp",
					"css",
					"go",
					"graphql",
					"html",
					"javascript",
					"json",
					"json5",
					"lua",
					"markdown",
					"php",
					"python",
					"regex",
					"rust",
					"sql",
					"toml",
					"tsx",
					"typescript",
					"vim",
					"vue",
					"yaml",
					"zig",
				},
				sync_install = false,
				auto_install = true,
				ignore_install = {},
				highlight = {
					-- `false` will disable the whole extension
					enable = true,
					disable = function(_, bufnr)
						return is_minified_file(bufnr) or is_file_too_large(bufnr)
					end,
				},
				indent = {
					enable = true,
				},
				matchup = {
					enable = true,
				},
			})
			vim.treesitter.language.register("markdown", { "mdx" })
			-- https://github.com/EmranMR/tree-sitter-blade/discussions/19
			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.blade = {
				install_info = {
					url = "https://github.com/EmranMR/tree-sitter-blade",
					files = { "src/parser.c" },
					branch = "main",
				},
				filetype = "blade",
			}
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufNewFile", "BufRead" },
		keys = {
			{ "<space>tc", ":TSContextToggle<CR>" },
		},
		opts = {
			max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
			min_window_height = 30,
			on_attach = function(bufnr)
				-- quickerではオフにする
				return vim.bo[bufnr].filetype ~= "qf"
			end,
		},
	},
}
