vim.g.netrw_nogx = 1 -- disable netrw's gx mapping.
vim.keymap.set({ "n", "v" }, "gx", "<Plug>(openbrowser-smart-search)", { noremap = true, silent = true })
vim.cmd([[
function! My_opens()
    execute 'OpenBrowser ' . substitute(expand('%:p'), '\v/mnt/(.)', '\1:/', 'c')
endfunction
]])
vim.keymap.set(
	{ "n", "v" },
	"<Leader>gh",
	":OpenGithubFile<CR>",
	{ noremap = true, silent = true, desc = "現在のファイルをGitHubで開く" }
)
