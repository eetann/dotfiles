vim.o.laststatus = 3
vim.o.showmode = false
vim.o.showcmd = true
vim.o.ruler = true

local function is_table_mode()
	local ok, is_active = pcall(vim.fn["tablemode#IsActive"])
	if not ok or is_active ~= 1 then
		return ""
	end
	return "TABLE"
end

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
		lualine_a = {
			"mode",
			[[vim.o.paste and 'PASTE' or '']],
			is_table_mode,
		},
		lualine_b = { "branch", "diff" },
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
		lualine_x = {
			{
				require("noice").api.status.message.get_hl,
				cond = require("noice").api.status.message.has,
			},
			{
				require("noice").api.status.command.get,
				cond = require("noice").api.status.command.has,
				color = { fg = "#ff9e64" },
			},
			{
				require("noice").api.status.mode.get,
				cond = require("noice").api.status.mode.has,
				color = { fg = "#ff9e64" },
			},
			{
				require("noice").api.status.search.get,
				cond = require("noice").api.status.search.has,
				color = { fg = "#ff9e64" },
			},
			"encoding",
			"fileformat",
			"filetype",
		},
		lualine_y = {},
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
	winbar = {
		lualine_a = { { "diagnostics", sources = { "nvim_lsp" } } },
		-- lspsagaのwinbarは被って見づらくなる & そもそも活用していないので非表示へ
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {
			{ "filetype", icon_only = true },
		},
		lualine_z = {
			{
				"filename",
				path = 1,
				newfile_status = true,
				symbols = {
					modified = "● ",
					readonly = "󰌾 ",
				},
			},
		},
	},
	inactive_winbar = {
		lualine_a = { { "diagnostics", sources = { "nvim_lsp" } } },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {
			{ "filetype", icon_only = true },
		},
		lualine_z = {
			{
				"filename",
				path = 1,
				newfile_status = true,
				symbols = {
					modified = "● ",
					readonly = "󰌾 ",
				},
			},
		},
	},
	tabline = {},
	extensions = {},
})
