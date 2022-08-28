require("toggleterm").setup({
	persist_mode = true,
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.4
		end
	end,
})

vim.keymap.set("n", "<Leader>tt", "<Cmd>ToggleTerm<CR>")
vim.keymap.set("n", "<Leader>t-", "<Cmd>ToggleTerm direction=horizontal<CR>")
vim.keymap.set("n", "<Leader>t\\", "<Cmd>ToggleTerm direction=vertical<CR>")
vim.keymap.set("n", "<Leader>tf", "<Cmd>ToggleTerm direction=float<CR>")

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
	cmd = 'lazygit --use-config-dir="$HOME/.config/lazygit"',
	dir = "git_dir",
	direction = "float",
	float_opts = {
		border = "double",
		width = function()
			return vim.fn.floor(vim.o.columns * 0.95)
		end,
		height = function()
			return vim.fn.floor(vim.o.lines * 0.9)
		end,
	},
	on_open = function(term)
		vim.cmd("startinsert!")
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
})

vim.keymap.set("n", "<leader>tg", function()
	lazygit:toggle()
end, { noremap = true, silent = true })
