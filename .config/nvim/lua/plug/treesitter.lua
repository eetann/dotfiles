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
		disable = function(_, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
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
require("treesitter-context").setup({
	max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
	on_attach = function(bufnr)
		-- quickerではオフにする
		return vim.bo[bufnr].filetype ~= "qf"
	end,
})
