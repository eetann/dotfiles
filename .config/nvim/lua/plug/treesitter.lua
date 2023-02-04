require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"bash",
		"c",
		"cpp",
		"css",
		"go",
		"graphql",
		"help",
		"html",
		"javascript",
		"json",
		"json5",
		"lua",
		"markdown",
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
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
})
require("treesitter-context").setup()
