return {
	"nvim-telescope/telescope.nvim",
	event = { "VeryLazy" },
	cmd = { "Telescope" },
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local actions = require("telescope.actions")
		local my_actions = require("plugins.telescope.actions")

		require("telescope").setup({
			defaults = {
				sorting_strategy = "ascending",
				layout_strategy = "vertical",
				layout_config = {
					prompt_position = "top",
					width = 0.95,
					vertical = {
						mirror = true,
						preview_cutoff = 10,
					},
				},
				file_ignore_patterns = {
					"git/",
					"node_modules/",
					"dist/",
					"dst/",
					".DS_Store",
					"%.jpg",
					"%.jpeg",
					"%.png",
					"%.svg",
					"%.gif",
					"%.zip",
					"%.o",
					"%.out",
				},
			},
			pickers = {
				find_files = {
					mappings = {
						i = {
							["<esc>"] = actions.close,
							["<C-c>"] = actions.close,
							["<CR>"] = my_actions.multi_selection_open,
							["<C-v>"] = my_actions.multi_selection_open_vsplit,
							["<C-x>"] = my_actions.multi_selection_open_split,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						},
					},
				},
				git_files = {
					file_ignore_patterns = { "node_modules/", ".git/" },
					mappings = {
						i = {
							["<esc>"] = actions.close,
							["<C-c>"] = actions.close,
							["<CR>"] = my_actions.multi_selection_open,
							["<C-v>"] = my_actions.multi_selection_open_vsplit,
							["<C-x>"] = my_actions.multi_selection_open_split,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						},
					},
				},
				live_grep = {
					additional_args = function()
						return { "--hidden" }
					end,
					mappings = {
						i = {
							["<esc>"] = actions.close,
							["<C-c>"] = actions.close,
							["<CR>"] = my_actions.multi_selection_open,
							["<C-v>"] = my_actions.multi_selection_open_vsplit,
							["<C-x>"] = my_actions.multi_selection_open_split,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						},
					},
				},
			},
		})
		require("plugins.telescope.keymap-basic")
		require("plugins.telescope.keymap-nb")
		require("plugins.telescope.keymap-lsp-log-level")
		require("plugins.telescope.keymap-lsp-capabilities")
		require("plugins.telescope.keymap-lsp-code-lenses")
	end,
}
