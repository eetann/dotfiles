return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	cmd = { "NvimTreeToggle" },
	keys = {
		{ "<Leader>T", "<CMD>NvimTreeToggle<CR>", desc = "ファイルツリー" },
	},
	config = function()
		local function my_on_attach(bufnr)
			local api = require("nvim-tree.api")
			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end
			api.config.mappings.default_on_attach(bufnr)
			vim.keymap.del("n", "s", { buffer = bufnr })
			vim.keymap.del("n", "<C-e>", { buffer = bufnr })

			vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
		end
		require("nvim-tree").setup({
			on_attach = my_on_attach,
			update_focused_file = {
				enable = true,
				update_root = {
					enable = false,
					ignore_list = {},
				},
				exclude = false,
			},
		})
	end,
}
