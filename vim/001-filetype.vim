autocmd vimrc FileType make setlocal noexpandtab
autocmd vimrc FileType html,css,javascript setlocal sw=2 sts=2 ts=2
autocmd vimrc FileType cpp setlocal sw=4 sts=4 ts=4
autocmd vimrc FileType help,quickrun nnoremap <buffer> q <C-w>c
autocmd vimrc FileType text,qf,quickrun setlocal wrap
autocmd vimrc FileType json syntax match Comment +\/\/.\+$+
" autocmd vimrc BufWritePre *.md :call MarkdownEOLTwoSpace()
autocmd vimrc BufNewFile,BufRead *.csv set filetype=csv
" autocmd vimrc BufNewFile,BufRead *.m set fileencoding=sjis
autocmd vimrc BufNewFile,BufRead *.m set filetype=matlab
let g:tex_flavor = "latex"

" ----Markdownのための設定
function! MarkdownEOLTwoSpace()
    let s:tmppos = getpos('.') " cursorの位置を記録しておく
    let s:iscode = 0
    let s:cursorline = 1

    " 最初にメタデータがあったらスキップ
    if getline(1)=~? '\v^(\-{3}|\+{3})'
        let s:cursorline +=1
        " 書きかけで1行だったら怖いので冗長でもこの判定
        while s:cursorline<=line('$')
            call cursor(s:cursorline, 1)
            if getline('.')=~? '\v^(\-{3}|\+{3})'
                break
            endif
            let s:cursorline +=1
        endwhile
    endif

    while s:cursorline<=line('$')
        call cursor(s:cursorline, 1)
        if getline('.')=~? '\v^```'
            if s:iscode == 0
                let s:iscode = 1
            else
                let s:iscode = 0
            endif
        elseif s:iscode == 0 && (getline('.') !~? '\v^(\-{3}|\+{3}|#+|\-\s|\+\s|\*\s)')
            " 見出しや区切り線には空白をいれない
            " 空行には行末空白なし
            .s/\v(\S\zs(\s{,1})|(\s{3,}))$/  /e
        endif
        let s:cursorline +=1
    endwhile

    call setpos('.', s:tmppos) " cursorの位置を戻す
endfunction
