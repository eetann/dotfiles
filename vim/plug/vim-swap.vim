UsePlugin 'vim-swap'
" 引数や配列の入れ替え

omap i, <Plug>(swap-textobject-i)
xmap i, <Plug>(swap-textobject-i)
omap a, <Plug>(swap-textobject-a)
xmap a, <Plug>(swap-textobject-a)
nmap g< <Plug>(swap-prev)
nmap g> <Plug>(swap-next)
nmap gs <Plug>(swap-interactive)

function! s:load_settings() abort
    let g:swap#rules = deepcopy(g:swap#default_rules)
    let g:swap#rules += [{
    \   'filetype': ['html', 'vue', 'md'],
    \   'delimiter': ['\s'],
    \   'surrounds': ['class="', '"', 0],
    \ },{
    \   'filetype': ['html', 'vue', 'md'],
    \   'delimiter': ['\s'],
    \   'surrounds': ["class='", "'", 0],
    \ }]
endfunction

autocmd vimrc User vim-swap call s:load_settings()
