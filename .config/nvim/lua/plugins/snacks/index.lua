return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = function()
		local picker = require("plugins.snacks.picker")
		local keys = picker.keys
		table.insert(keys, {
			"<space>.",
			function()
				require("snacks").scratch()
			end,
			desc = "Toggle Scratch Buffer",
		})
		-- keys = {unpack(keys), foo.keys}
		return keys
	end,
	opts = function()
		return {
			picker = require("plugins.snacks.picker").config,
		}
	end,
}
