return {
	"nvimdev/lspsaga.nvim",
  cmd = {"Lspsaga"},
	lazy = true,
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	-- キーマップは ./attach.lua
	opts = {
		scroll_preview = {
			scroll_down = "<C-d>",
			scroll_up = "<C-u>",
		},
		finder = {
			edit = { "o", "<CR>" },
			vsplit = { "\\", "|", "<C-v>" },
			split = { "-", "<C-x>" },
			tabe = "t",
			quit = { "q", "<ESC>" },
		},
		definition = {
			edit = "o",
			vsplit = "<C-v>",
			split = "<C-x>",
			tabe = "t",
			quit = "q",
			close = "<Esc>",
		},
		lightbulb = {
			enable = false,
		},
		diagnostic = {
			jump_num_shortcut = false,
			keys = {
				exec_action = "o",
				quit = "q",
				toggle_or_jump = "<CR>",
				quit_in_show = { "q", "<Esc>" },
			},
		},
		symbol_in_winbar = {
			enable = false,
		},
	},
}
