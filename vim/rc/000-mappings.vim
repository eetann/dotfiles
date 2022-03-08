let mapleader = "\<Space>" " leaderキーの割当を変える

" 誤爆防止のためにremapping
imap <C-@> <C-[>
nnoremap q <NOP>
nnoremap <leader>q q
" sはclで代用する
nnoremap s <Nop>

" 表示行と移動行を合わせる これをやると相対行表示がずれるのでオフ
" nnoremap j gj
" nnoremap k gk
" 画面移動
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
" 分割(水平&垂直)
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
" ウィンドウを閉じる
nnoremap sc <C-w>c
if !has('nvim')
  nnoremap [b :<C-u>bprevious<CR>
  nnoremap ]b :<C-u>bnext<CR>

  " ターミナル設定
  tnoremap <C-q> <C-w><C-c>:close!<CR>
  " ウィンドウを閉じずにバッファを閉じる
  nnoremap sq :<C-u>call <SID>my_buffer_delete()<CR>
  function! s:my_buffer_delete()
    let s:now_bn = bufnr("%")
    bnext
    execute 'bdelete' . s:now_bn
  endfunction
endif
" InsertModeでカーソル移動
inoremap <C-b> <left>
inoremap <C-f> <right>
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$
" コマンド履歴のフィルタリングを<C-p>と<C-n>にも追加
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
" コマンドライン内でのカーソル移動をInsertModeと同じに
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <HOME>
cnoremap <C-e> <End>
" quickfixのコマンド
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :<C-u>cfirst<CR>
nnoremap ]Q :<C-u>clast<CR>
"
" カーソル前方の数字に対してインクリメント&デクリメント
nnoremap s<C-a> :call search("[0-9]",'b', line("."))<CR><C-a>
nnoremap s<C-x> :call search("[0-9]",'b', line("."))<CR><C-x>

" コマンド履歴から、｢e hoge1.cpp｣のようなコマンドを探し、末尾にカーソルを置く
" 上記の<space><C-a>と合わせると、課題で楽
nnoremap <space>:e q:?^e\s\S<CR>$

" 行頭から行末までを改行を含めずにヤンク
nnoremap Y mz0vg$y`z:delmarks z<CR>
" 選択範囲をヤンクしたら選択範囲の末尾へ移動
xnoremap gy y`>
" VisualModeで置換対象ペースト時のヤンク入れ替えを防ぐ
xnoremap <expr> p 'pgv"'.v:register.'ygv<esc>'
" ペーストした範囲をvisualModeで選択
nnoremap sgv `[v`]
" 下の行に貼り付けてカーソル位置はそのまま
nnoremap sp mz:put<CR>`[v`]=`zdmz
" 上の行に貼り付けてカーソル位置はそのまま
nnoremap sP mz:put!<CR>`[v`]=`zdmz
" 下の行に貼り付けたら貼り付けの末尾へ
nnoremap sgp :put<CR>`[v`]=`>$
" 上の行へ貼り付けたら貼り付けの先頭(インデントじゃない)へ
nnoremap sgP :put!<CR>`[v`]=`<^
" 全選択コピー yank
nnoremap sy :%y<CR>
" 今のファイル名をヤンク get filename
nnoremap sgf :let @+=expand('%')<CR>:echo 'Clipboard << ' . @+<CR>
" 直前にechoを実行していたらヤンク get echo
nnoremap sge :call <SID>my_yank_echo()<CR>:echo 'Clipboard << ' . @+<CR>
function! s:my_yank_echo()
    let s:echo_hist = histget('cmd', -1)
    if s:echo_hist =~ '^echo '
        let @z = substitute(s:echo_hist, '^echo\s','echomsg ', '')
        execute "normal ;\<C-r>z\<CR>"
        let @+ = execute('1messages')
    endif
endfunction
" 直前の検索をヤンク get 検索/
nnoremap sg/ :let @+ = histget("search",-1)<CR>:echo 'Clipboard << ' . @+<CR>

" 一気に置換するときは以下ではなく、/or?検索->cgn->n.n.nnn.
" cursor下の単語をハイライトと置換
nnoremap * "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
nnoremap # "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>:%s/<C-r>///g<Left><Left>
" 選択範囲の検索と置換
xnoremap * :<C-u>call <SID>set_vsearch()<CR>mz/<C-r>/<CR>`zdmz
xnoremap # :<C-u>call <SID>set_vsearch()<CR>/<C-r>/<CR>:%s/<C-r>///g<Left><Left>
function! s:set_vsearch()
    silent normal gv"zy
    let @/ = '\V' . substitute(escape(@z, '/\'), '\n', '\\n', 'g')
endfunction

" digraph f<C-k>xxで対応文字に飛べる
" カッコ
digraphs j( 65288  " （
digraphs j) 65289  " ）
digraphs j[ 12300  " 「
digraphs j] 12301  " 」
digraphs j{ 12302  " 『
digraphs j} 12303  " 』

" 句読点
digraphs j, 12289  " 、
digraphs j. 12290  " 。
digraphs j< 65292  " ，
digraphs j> 65294  " ．
digraphs j! 65281  " ！
digraphs j? 65311  " ？
digraphs j: 65306  " ：

" その他
digraphs j~ 12316  " 〜
digraphs j/ 12539  " ・
digraphs js 12288  " 　
digraphs jj 106  " 潰されるjのために

" fjde で 'で'に飛べる
noremap fj f<C-k>
noremap Fj F<C-k>
noremap tj t<C-k>
noremap Tj T<C-k>


" 切り替え
nnoremap <Plug>(my-switch) <Nop>
nmap <Leader>s <Plug>(my-switch)
nnoremap <silent> <Plug>(my-switch)w :<C-u>setl wrap! wrap?<CR>
nnoremap <silent> <Plug>(my-switch)p :<C-u>setl paste! paste?<CR>
nnoremap <silent> <ESC><ESC> :<C-u>set nohlsearch! hlsearch?<CR>

" vimrcの適用
nnoremap <F5> :<C-u>source $MYVIMRC<CR>

" InsertModeでccc を入力し、エスケープでコメント線
inoreabbrev <expr> ccc repeat('-', 70 - virtcol('.'))

" ----cursorの形をモードで変化(ターミナルによる)------------------
if has('vim_starting') " reloadableにするため
    " 挿入モード時に点滅の縦棒タイプのcursor
    let &t_SI .= "\e[5 q"
    " ノーマルモード時に非点滅のブロックタイプのcursor
    let &t_EI .= "\e[2 q"
    " 置換モード時に非点滅の下線タイプのcursor
    let &t_SR .= "\e[4 q"
endif
