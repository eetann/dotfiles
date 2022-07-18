vim.g.netrw_nogx = 1 -- disable netrw's gx mapping.
vim.keymap.set({ "n", "v" }, "gx", "<Plug>(openbrowser-smart-search)", { noremap = true, silent = true })
vim.cmd([[
function! My_opens()
    execute 'OpenBrowser ' . substitute(expand('%:p'), '\v/mnt/(.)', '\1:/', 'c')
endfunction
]])
