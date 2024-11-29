local function is_file_too_large(bufnr)
	local size = vim.api.nvim_buf_line_count(bufnr)
	return size > 10000
end
local function is_minified_file(bufnr)
	-- is likely minified if one of the first 5 lines is longer than 1000 characters
	for i = 0, 5 do
		local line = vim.api.nvim_buf_get_lines(bufnr, i, i + 1, false)[1]
		if #line > 1000 then
			return true
		end
	end
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
			return is_file_too_large(bufnr) or is_minified_file(bufnr)
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
