local noice = require("noice")

local function myMiniView(pattern)
	return {
		view = "mini",
		filter = {
			event = "msg_show",
			kind = "",
			find = pattern,
		},
	}
end

noice.setup({
	-- cmdline = {
	-- 	view = "cmdline",
	-- },
	routes = {
		{
			filter = {
				event = "cmdline",
				find = "^%s*[/?]",
			},
			view = "cmdline",
		},
		{
			view = "notify",
			filter = { event = "msg_showmode" },
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
		myMiniView("Already at .* change"),
		myMiniView("written"),
		myMiniView("yanked"),
		myMiniView("more lines"),
		myMiniView("fewer lines"),
		myMiniView("change; before"),
		myMiniView("change; after"),
		myMiniView("line less"),
		myMiniView("search hit .*, continuing at"),
		myMiniView("E486: Pattern not found"),
	},
})
