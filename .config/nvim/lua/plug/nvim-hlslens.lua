require("hlslens").setup()

local opts = { silent = true }

vim.keymap.set("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
vim.keymap.set("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)

local hlslens = require("hlslens")
vim.keymap.set("n", "*", function()
	local current_word = vim.fn.expand("<cword>")
	vim.fn.setreg("/", current_word)
	vim.opt.hlsearch = true
	hlslens.start()
end, opts)
vim.keymap.set("n", "#", function()
	local current_word = vim.fn.expand("<cword>")
	vim.opt.hlsearch = true
	hlslens.start()
	vim.api.nvim_feedkeys(":%s/" .. current_word .. "//g", "n", false)
	-- :%s/word/CURSOR/g
	local ll = vim.api.nvim_replace_termcodes("<Left><Left>", true, true, true)
	vim.api.nvim_feedkeys(ll, "n", false)
end, opts)

local function getVisualSelection()
	vim.cmd('noau normal! "vy')
	---@diagnostic disable-next-line: missing-parameter
	local text = vim.fn.getreg("v")
	vim.fn.setreg("v", {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ""
	end
end
vim.keymap.set("v", "*", function()
	local current_word = getVisualSelection()
	vim.opt.hlsearch = true
	hlslens.start()
	-- let @/ = '\V' . substitute(escape(@z, '/\'), '\n', '\\n', 'g')
	-- print(vim.fn.escape(current_word, "\\"))
	-- vim.fn.setreg("/", vim.fn.substitute(vim.fn.escape(current_word, "\\"), "\\n", "\\\\n", "g"))
	vim.fn.setreg("/", current_word)
end, opts)

vim.keymap.set("v", "#", function()
	local current_word = getVisualSelection()
	vim.opt.hlsearch = true
	hlslens.start()
	vim.api.nvim_feedkeys(":%s/" .. current_word .. "//g", "n", false)
	-- :%s/word/CURSOR/g
	local ll = vim.api.nvim_replace_termcodes("<Left><Left>", true, true, true)
	vim.api.nvim_feedkeys(ll, "n", false)
end, opts)
