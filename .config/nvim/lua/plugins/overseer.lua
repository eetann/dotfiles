return {
	"stevearc/overseer.nvim",
	dependencies = {
		{
			"stevearc/dressing.nvim",
			opts = {
				input = {
					enabled = false,
				},
			},
		},
		{ "nvim-telescope/telescope.nvim" },
	},
	keys = {
		{ "<space>r", "<CMD>OverseerRun<CR>" },
		{ "<space>R", "<CMD>OverseerToggle<CR>" },
	},
	opts = {
		templates = {
			"builtin",
			"first-template",
			"cmd-table-no-pipe",
			"blog.open-preview",
			"blog._update-mdx",
			"blog.convert-image",
			"cpp.gpp-build-run",
			"cpp.gpp-build-only",
			"atcoder.test-submit",
			"atcoder.test",
			"atcoder.submit",
		},
	},
}
