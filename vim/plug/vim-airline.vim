UsePlugin 'vim-airline'
" ステータスライン

set laststatus=2 " ステータスラインを常に表示
set noshowmode   " 現在のモードを日本語表示しない
set showcmd      " 打ったコマンドをステータスラインの下に表示
set ruler        " ステータスラインの右側にカーソルの現在位置を表示する

let g:airline_theme = 'powerlineish'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#wordcount#enabled = 0

" tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#alt_sep = 1

let g:airline#extensions#default#layout = [
\ [ 'a', 'b', 'c' ],
\ [ 'x', 'y', 'z', 'warning' , 'error']]
let g:airline#extensions#default#section_truncate_width = {
\ 'b': 79,
\ 'x': 60,
\ 'y': 100,
\ 'z': 45,
\ 'warning': 80,
\ 'error': 80,
\ }
let g:airline_section_z = '%3v:%l/%L %3p%%'
