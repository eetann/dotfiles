autocmd vimrc FileType make setlocal noexpandtab
autocmd vimrc FileType html,css,javascript,json,vue,sh,dockerfile,typescript,typescriptreact setlocal sw=2 sts=2 ts=2
autocmd vimrc FileType cpp setlocal sw=4 sts=4 ts=4
autocmd vimrc FileType css,help setlocal iskeyword+=-
autocmd vimrc FileType help,quickrun nnoremap <buffer> q <C-w>c
autocmd vimrc FileType text,qf,quickrun setlocal wrap
autocmd vimrc FileType json syntax match Comment +\/\/.\+$+
autocmd vimrc FileType markdown,tex setlocal wrap
autocmd vimrc BufEnter *.tex setlocal indentexpr=""
autocmd vimrc BufNewFile,BufRead *.csv set filetype=csv
autocmd vimrc BufNewFile,BufRead *.m set filetype=matlab
let g:tex_flavor = "latex"
autocmd vimrc FileType gitcommit startinsert
