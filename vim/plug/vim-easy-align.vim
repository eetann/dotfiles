UsePlugin 'vim-easy-align'
" 指定した文字で整形

xmap ga <Plug>(LiveEasyAlign)
nmap ga <Plug>(LiveEasyAlign)
" コメントや文字列中でも有効化
let g:easy_align_ignore_groups = []
