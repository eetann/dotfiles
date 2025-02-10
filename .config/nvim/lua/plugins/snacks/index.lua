return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = function()
		local picker = require("plugins.snacks.picker")
		local keys = picker.keys
		-- keys = {unpack(keys), foo.keys}
		return keys
	end,
	opts = function()
		return {
			picker = require("plugins.snacks.picker").config,
		}
	end,
}
