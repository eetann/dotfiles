return {
	"voldikss/vim-translator",
	cmd = { "TranslateW", "TranslateWV" },
	keys = {
		{ "<Space>tt", "<Plug>TranslateW", mode = "n" },
		{ "<Space>tt", "<Plug>TranslateWV", mode = "v" },
	},
	init = function()
		vim.g.translator_target_lang = "ja"
		vim.g.translator_default_engines = { "google" }
		vim.g.translator_history_enable = true
	end,
}
