UsePlugin 'open-browser.vim'
" # プレビューをブラウザで開く

let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
function! My_opens()
    execute 'OpenBrowser ' . substitute(expand('%:p'), '\v/mnt/(.)', '\1:/', 'c')
endfunction
