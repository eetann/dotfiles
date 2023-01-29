local noice = require("noice")

local function myMiniView(pattern, kind)
	kind = kind or ""
	return {
		view = "mini",
		filter = {
			event = "msg_show",
			kind = kind,
			find = pattern,
		},
	}
end

noice.setup({
	messages = {
		view_search = "mini",
	},
	routes = {
		{
			filter = {
				event = "notify",
				warning = true,
				find = "failed to run generator.*is not executable",
			},
			opts = { skip = true },
		},
		{
			filter = {
				event = "notify",
				find = "no matching language servers",
			},
			opts = { skip = true },
		},
		{
			filter = {
				event = "notify",
				find = "is not supported by any of the servers registered for the current buffer",
			},
			opts = { skip = true },
		},
		myMiniView("Already at .* change"),
		myMiniView("written"),
		myMiniView("yanked"),
		myMiniView("more lines?"),
		myMiniView("fewer lines?"),
		myMiniView("fewer lines?", "lua_error"),
		myMiniView("change; before"),
		myMiniView("change; after"),
		myMiniView("line less"),
		myMiniView("lines indented"),
		myMiniView("No lines in buffer"),
		myMiniView("search hit .*, continuing at", "wmsg"),
		myMiniView("E486: Pattern not found", "emsg"),
	},
})

vim.cmd("highlight! link LspSignatureActiveParameter @text.warning")
