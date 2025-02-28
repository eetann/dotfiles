return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy",
	priority = 1000, -- needs to be loaded in first
	config = function()
		require("tiny-inline-diagnostic").setup({
			options = {
				multilines = {
					enabled = true,
					always_show = true,
				},
				overwrite_events = { "DiagnosticChanged" },
			},
		})
		vim.diagnostic.config({ virtual_text = false })
	end,
}
