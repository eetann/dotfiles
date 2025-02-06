return {
	"folke/snacks.nvim",
	event = { "VeryLazy" },
	keys = function()
		local picker = require("plugins.snacks.picker")
		local keys = picker.keys
		-- keys = {unpack(keys), foo.keys}
		return keys
	end,
	config = function()
		-- ...
	end,
}
