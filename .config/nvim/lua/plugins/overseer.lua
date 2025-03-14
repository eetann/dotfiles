return {
	"stevearc/overseer.nvim",
	keys = {
		{ "<space>r", "<CMD>OverseerRun<CR>" },
		{ "<space>R", "<CMD>OverseerToggle<CR>" },
	},
	opts = {
		templates = {
			"builtin",
			"blog.open-preview",
			"blog._update-mdx",
			"blog.convert-image",
			"cpp.gpp-build-run",
			"cpp.gpp-build-only",
			"cpp.gpp-debug-build",
			"atcoder.test-submit",
			"atcoder.test",
			"atcoder.submit",
			"lsp.show-log",
			"lua.run_luafile",
			"deno.deno_run",
			"deno.deno_test",
		},
	},
}
