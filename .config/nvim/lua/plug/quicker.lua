require("quicker").setup({
	opts = {
		buflisted = true,
	},
	keys = {
		{ "ge", "<cmd>lua require('quicker').expand()<CR>", desc = "Expand quickfix content" },
		{ "gE", "<cmd>lua require('quicker').collapse()<CR>", desc = "Collapse quickfix content" },
		{ "gr", "<cmd>lua require('quicker').refresh()<CR>", desc = "Refresh quickfix content" },
	},
})
