require("smoothcursor").setup({
	priority = 1,
	fancy = {
		enable = true,
		head = { cursor = "", texthl = "SmoothCursor", linehl = nil },
		body = {
			{ cursor = "", texthl = "SmoothCursorOrange" },
			{ cursor = "", texthl = "SmoothCursorOrange" },
			{ cursor = "●", texthl = "SmoothCursorOrange" },
			{ cursor = "●", texthl = "SmoothCursorOrange" },
			{ cursor = "•", texthl = "SmoothCursorOrange" },
			{ cursor = ".", texthl = "SmoothCursorOrange" },
			{ cursor = ".", texthl = "SmoothCursorOrange" },
		},
		tail = { cursor = nil, texthl = "SmoothCursor" },
	},
	disabled_filetypes = {
		"TelescopePrompt",
		"TelescopeResults",
		"gitblame",
		"css",
		"noice",
		"LspsagaHover",
		"lazy",
	},
})
