return {
	"EdenEast/nightfox.nvim",
	config = function()
		require("nightfox").setup({
			options = {
				transparent = true,
			},
		})
		vim.cmd("colorscheme terafox")
		vim.cmd("highlight! link WinSeparator GlyphPalette2")
	end,
}
