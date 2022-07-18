vim.o.laststatus = 3
vim.o.showmode = false
vim.o.showcmd = true
vim.o.ruler = true

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "powerline",
		component_separators = { left = " ", right = " " },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {},
		always_divide_middle = true,
		globalstatus = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {
			{
				"filename",
				file_status = true, -- readonly, modified
				path = 1, -- Relative path
				shorting_target = 40,
				symbols = {
					modified = " ●",
					readonly = " ",
					unnamed = "[No Name]",
				},
			},
		},
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = {
			{
				"diagnostics",
				source = { "nvim-lsp" },
			},
		},
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
})
