return {
	"mechatroner/rainbow_csv",
	ft = { "csv" },
	-- TODO: ハイライトがレインボーにならない
	init = function()
		vim.g.disable_rainbow_hover = 1
	end,
}
