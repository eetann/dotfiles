return {
	"stevearc/quicker.nvim",
	event = "FileType qf",
	opts = {
		keys = {
			{ ">", "<cmd>lua require('quicker').expand()<CR>", desc = "Expand quickfix content" },
			{ "<", "<cmd>lua require('quicker').collapse()<CR>", desc = "Collapse quickfix content" },
			{ "gr", "<cmd>lua require('quicker').refresh()<CR>", desc = "Refresh quickfix content" },
		},
	},
}
