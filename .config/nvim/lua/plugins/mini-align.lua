return {
	"nvim-mini/mini.align",
	version = "*",
	keys = {
		{ "ga", mode = { "n", "x" }, desc = "align with preview" },
	},
	opts = {
		mappings = {
			start = "",
			start_with_preview = "ga",
		},
	},
}
