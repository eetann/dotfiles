local noice = require("noice")
noice.setup({
	routes = {
		{
			view = "notify",
			filter = { event = "msg_showmode" },
		},
		{
			view = "mini",
			filter = {
				event = "msg_show",
				kind = "",
				find = "written",
			},
		},
		{
			view = "mini",
			filter = {
				event = "msg_show",
				kind = "",
				find = "yanked",
			},
		},
		{
			view = "mini",
			filter = {
				event = "msg_show",
				kind = "",
				find = "more lines",
			},
		},
		{
			view = "mini",
			filter = {
				event = "msg_show",
				kind = "",
				find = "fewer lines",
			},
		},
		{
			view = "notify",
			filter = {
				event = "msg_show",
				kind = "echo",
				find = "window resize mode",
			},
			opts = {
				replace = true,
				merge = false,
			},
		},
		{
			view = "mini",
			filter = {
				event = "msg_show",
				kind = "search_count",
			},
		},
	},
})
