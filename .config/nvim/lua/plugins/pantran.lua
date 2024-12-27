return {
	"potamides/pantran.nvim",
	cmd = "Pantran",
	keys = {
		{ "<space>tr", "<CMD>Pantran<CR>" },
		-- TODO: visualモードで定義
	},
	opts = {
		default_engine = "google",
		engines = {
			google = {
				fallback = {
					default_source = "en",
					default_target = "ja",
				},
			},
		},
	},
}
