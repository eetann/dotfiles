UsePlugin 'neosnippet.vim'
" スニペット管理

let g:neosnippet#snippets_directory = ['~/dotfiles/vim/snippet']
" let g:neosnippet#snippets_directory+=['~/.vim/dein/repos/github.com/honza/vim-snippets/snippets']
let g:neosnippet#enable_completed_snippet = 1 " 関数スニペットを展開
let g:neosnippet#expand_word_boundary = 0 " jump時に間違えて補完されないようにオフ
let g:neosnippet#scope_aliases = {}
let g:neosnippet#scope_aliases["typescript"] = "typescript,typescriptreact,react"
" imap <C-k> <Plug>(neosnippet_expand_or_jump)
" smap <C-k> <Plug>(neosnippet_expand_or_jump)
" xmap <C-k> <Plug>(neosnippet_expand_target)
