vim.g.tex_flavor = "latex"
local group_name = "my_nvim_rc"

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group_name,
	pattern = { "qf", "help", "man" },
	callback = function()
		vim.cmd([[
      nnoremap <silent><buffer> q <Cmd>:quit<CR> 
      set nobuflisted 
    ]])
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group_name,
	pattern = { "make" },
	callback = function()
		vim.opt_local.expandtab = false
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group_name,
	pattern = { "cpp,python" },
	callback = function()
		vim.cmd([[
    setlocal sw=4 sts=4 ts=4
    ]])
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group_name,
	pattern = { "css,help" },
	callback = function()
		vim.cmd([[
    setlocal iskeyword+=-
    ]])
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group_name,
	pattern = { "text,qf,quickrun,markdown,tex" },
	callback = function()
		vim.opt_local.wrap = true
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group_name,
	pattern = { "json" },
	callback = function()
		vim.cmd([[
    syntax match Comment +\/\/.\+$+
    ]])
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = group_name,
	pattern = { "*.tex" },
	callback = function()
		vim.opt_local.indentexpr = ""
	end,
})

vim.api.nvim_create_autocmd({ "BufNewFile,BufRead" }, {
	group = group_name,
	pattern = { "*.csv" },
	callback = function()
		vim.opt_local.filetype = "csv"
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group_name,
	pattern = { "gitcommit" },
	callback = function()
		vim.cmd([[
    call feedkeys('I', 'n')
    ]])
	end,
})
