autocmd vimrc FileType make setlocal noexpandtab
autocmd vimrc FileType html,css,javascript,vue setlocal sw=2 sts=2 ts=2
autocmd vimrc FileType cpp setlocal sw=4 sts=4 ts=4
autocmd vimrc FileType css,help setlocal iskeyword+=-
autocmd vimrc FileType help,quickrun nnoremap <buffer> q <C-w>c
autocmd vimrc FileType text,qf,quickrun setlocal wrap
autocmd vimrc FileType json syntax match Comment +\/\/.\+$+
autocmd vimrc FileType markdown setlocal wrap
autocmd vimrc BufNewFile,BufRead *.csv set filetype=csv
autocmd vimrc BufNewFile,BufRead *.m set filetype=matlab
let g:tex_flavor = "latex"

" gitcommitのための設定
let s:git_commit_prefixs = [
    \ {'word':'🎉initial commit', 'menu':'初めてのコミット',       'kind': 'pre'},
    \ {'word':'🐛',               'menu':'バグ修正',               'kind': 'pre'},
    \ {'word':'👍',               'menu':'機能改善',               'kind': 'pre'},
    \ {'word':'✨',               'menu':'機能追加',               'kind': 'pre'},
    \ {'word':'🎨',               'menu':'デザイン変更のみ',       'kind': 'pre'},
    \ {'word':'🚧',               'menu':'工事中',                 'kind': 'pre'},
    \ {'word':'📝',               'menu':'文言修正',               'kind': 'pre'},
    \ {'word':'♻️',                'menu':'リファクタリング',       'kind': 'pre'},
    \ {'word':'🔥',               'menu':'削除',                   'kind': 'pre'},
    \ {'word':'🚀',               'menu':'パフォーマンス改善',     'kind': 'pre'},
    \ {'word':'🔒',               'menu':'セキュリティ関連の改善', 'kind': 'pre'},
    \ {'word':'⚙ ',               'menu':'config変更 ',            'kind': 'pre'},
    \ {'word':'📚',               'menu':'ドキュメント',           'kind': 'pre'},
    \ {'word':'➕',               'menu':'追加',                   'kind': 'pre'},
    \ {'word':'➖',               'menu':'削除',                   'kind': 'pre'},
    \ ]

function! CompleteGitCommit() abort
    if empty(getline(1))
        call complete(col('.'), s:git_commit_prefixs)
    endif
    return ''
endfunction

autocmd vimrc FileType gitcommit startinsert | call feedkeys("\<C-R>=CompleteGitCommit()\<CR>")
