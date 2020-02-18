let mapleader = "\<Space>" " leaderキーの割当を変える

" 入れ替え
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;
nnoremap q; q:
" 誤爆防止のためにremapping
imap <C-@> <C-[>
nnoremap q <NOP>
nnoremap <leader>q q
" sはclで代用する
nnoremap s <Nop>

" 表示行と移動行を合わせる
nnoremap j gj
nnoremap k gk
" 遠いので近くのキーに
map H ^
map L $
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
" ウィンドウを閉じずにバッファを閉じる
nnoremap sq :<C-u>call <SID>my_buffer_delete()<CR>
function! s:my_buffer_delete()
    let s:now_bn = bufnr("%")
    bnext
    execute 'bdelete' . s:now_bn
endfunction
" バッファもウィンドウも閉じる
nnoremap sQ :<C-u>bd!<CR>
nnoremap sC :<C-u>bd!<CR>
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
" バッファの移動
nnoremap <space><Tab>p :<C-u>bprevious<CR>
nnoremap <space><Tab>n :<C-u>bnext<CR>

" ターミナル設定
nnoremap st :term<CR>
tnoremap <space><Tab> <C-w>:bprevious!<CR>
tnoremap <C-Tab> <C-w>:bnext!<CR>
tnoremap <C-q> <C-w><C-c>:close!<CR>

" カーソル前方の数字に対してインクリメント&デクリメント
nnoremap <space><C-a> :call search("[0-9]",'b', line("."))<CR><C-a>
nnoremap <space><C-x> :call search("[0-9]",'b', line("."))<CR><C-x>

" コマンド履歴から、｢e hoge1.cpp｣のようなコマンドを探し、末尾にカーソルを置く
" 上記の<space><C-a>と合わせると、課題で楽
nnoremap <space>;e q:?^e\s\S<CR>$

" cursor位置から行末までを改行を含めずにヤンク
nnoremap Y mzvg$y`z:delmarks z<CR>
" 行頭から行末までを改行を含めずにヤンク
nnoremap yY mz0vg$y`z:delmarks z<CR>
" 選択範囲をヤンクしたら選択範囲の末尾へ移動
xnoremap gy y`>
" VisualModeで置換対象ペースト時のヤンク入れ替えを防ぐ
xnoremap <expr> p 'pgv"'.v:register.'ygv<esc>'
" ペーストした範囲をvisualModeで選択
nnoremap sgv `[v`]
" 下or上の行に貼り付けてカーソル位置はそのまま
nnoremap sp mz:put<CR>`[v`]=`zdmz
nnoremap sP mz:put!<CR>`[v`]=`zdmz
" 下の行に貼り付けたら貼り付けの末尾へ
nnoremap sgp :put<CR>`[v`]=`>$
" 上の行へ貼り付けたら貼り付けの先頭(インデントじゃない)へ
nnoremap sgP :put!<CR>`[v`]=`<^
" 全選択コピー
nnoremap sy :%y<CR>
" 今のファイル名取得
nnoremap sgg :let @+=expand('%')<CR>
" 直前にechoを実行していたらヤンク
nnoremap sge :call My_yank_echo()<CR>
function! My_yank_echo()
    let s:echo_hist = histget('cmd', -1)
    if s:echo_hist =~ '^echo '
        let @z = substitute(s:echo_hist, '^echo\s','echomsg ', '')
        execute "normal ;\<C-r>z\<CR>"
        let @+ = execute('1messages')
    endif
endfunction
" 直前の検索をヤンク
nnoremap sg/ :let @+ = histget("search",-1)<CR>

" ESC2度押しでハイライトの切り替え
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>
" 一気に置換するときは以下ではなく、/or?検索->cgn->n.n.nnn.
" cursor下の単語をハイライトと置換
nnoremap * <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
nnoremap # "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>:%s/<C-r>///g<Left><Left>
" 選択範囲の検索と置換
xnoremap <silent> <Space> mz:call <SID>set_vsearch()<CR>:set hlsearch<CR>`zdmz
xnoremap * :<C-u>call <SID>set_vsearch()<CR>mz/<C-r>/<CR>`zdmz
xnoremap # :<C-u>call <SID>set_vsearch()<CR>/<C-r>/<CR>:%s/<C-r>///g<Left><Left>
function! s:set_vsearch()
    silent normal gv"zy
    let @/ = '\V' . substitute(escape(@z, '/\'), '\n', '\\n', 'g')
endfunction

" 設定ファイル短縮e
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