" 文字関連の設定
set encoding=utf-8
set fileencodings=utf-8,sjis " この順番でMATLABとそれ以外がうまくいった
scriptencoding utf-8
set ambiwidth=double " □や○文字が崩れる問題を解決
set nrformats= "数増減は10進数で扱う(<C-a>や<C-x>)
let mapleader = "\<Space>" " leaderキーの割当を変える

" ----入れ替え----------------------------------------------------
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;
nnoremap q; q:

" ----reset augroup-----------------------------------------------
" 再読込時に2度設定しないように、初期化
augroup vimrc
    autocmd!
augroup END

" ----移動系------------------------------------------------------
set scrolloff=3 " 上下のスクロールの余裕を確保する
" 表示行と移動行を合わせる
nnoremap j gj
nnoremap k gk
" 遠いので近くのキーに
map H ^
map L $
" sはclで代用する
nnoremap s <Nop>
" 画面移動
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
" 分割(水平&垂直)
nnoremap sb :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
" ウィンドウを閉じる
nnoremap sc <C-w>c
" ウィンドウを閉じずにバッファを閉じる
nnoremap sq :<C-u>call <SID>my_buffer_delete()<CR>
function! s:my_buffer_delete()
    let s:now_bn = bufnr("%")
    bprevious
    execute 'bdelete' . s:now_bn
endfunction
nnoremap sQ :<C-u>bd!<CR>
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
nnoremap <C-p> :<C-u>bprevious<CR>
nnoremap <C-n> :<C-u>bnext<CR>
" ターミナル設定
nnoremap st :term<CR>
tnoremap <C-p> <C-w>:bprevious!<CR>
tnoremap <C-n> <C-w>:bnext!<CR>
tnoremap <C-q> <C-w><C-c>:close!<CR>

"---- コピペ関連--------------------------------------------------
set clipboard&
set clipboard^=unnamedplus
set clipboard-=autoselect
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
nnoremap sp mzox<Esc>"_x]p`z:delmarks z<CR>
nnoremap sP mzOx<Esc>"_x]p`z:delmarks z<CR>
" 下の行に貼り付けたら貼り付けの末尾へ
nnoremap sgp ox<Esc>"_x]p`]
" 上の行へ貼り付けたら貼り付けの先頭へ
nnoremap sgP Ox<Esc>"_x]p`[
" 全選択コピー
nnoremap sy :%y<CR>
nnoremap sgg :let @+=expand('%')<CR>
nnoremap sge q:?echo<CR>0vg$"zy<CR>:redir @a<CR>:<C-r>z<BS><CR>:redir end<CR>:let @+=@a<CR>

" ----タブ設定----------------------------------------------------
set expandtab " インデントをタブの代わりにスペース
set tabstop=4 "タブ幅をスペース4つ分にする
set softtabstop=4 " 連続空白に対してTabやBackSpaceでcursorが動く幅
set autoindent    " 改行時に前の行のintentを継続する
set smartindent   " 改行時に入力された行の末尾に合わせて次行のintentを増減
set shiftwidth=4  " smartindentでずれる幅
set pastetoggle=<F3>

" ----文字列検索--------------------------------------------------
set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set shortmess-=S " 検索時に検索件数メッセージを表示
" ESC2度押しでハイライトの切り替え
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>
" cursor下の単語をハイライトと置換
nnoremap <silent> <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
nnoremap # "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>:%s/<C-r>///g<Left><Left>
" 選択範囲の検索と置換
xnoremap <silent> <Space> mz:call <SID>set_vsearch()<CR>:set hlsearch<CR>`z
xnoremap * :<C-u>call <SID>set_vsearch()<CR>/<C-r>/<CR>
xnoremap # :<C-u>call <SID>set_vsearch()<CR>/<C-r>/<CR>:%s/<C-r>///g<Left><Left>
function! s:set_vsearch()
    silent normal gv"zy
    let @/ = '\V' . substitute(escape(@z, '/\'), '\n', '\\n', 'g')
endfunction
" html記述に合わせてファイルの相対パスが/始まりでも認識できるようにする
set includeexpr=substitute(v:fname,'^\\/','','') 

" ----grepの設定
" 日本語grepする。要go get取得
set grepprg=jvgrep
" grepはquickfixで開く
autocmd vimrc QuickFixCmdPost *grep* cwindow
let Grep_Skip_Dirs = '.svn .git'

" ----Markdownのための設定
function! MarkdownEOLTwoSpace()
    let s:tmppos = getpos('.') " cursorの位置を記録しておく
    let s:iscode = 0
    let s:cursorline = 1
    while s:cursorline<=line('$')
        call cursor(s:cursorline, 1)
        if getline('.')=~? '\v^```'
            if s:iscode == 0
                let s:iscode = 1
            else
                let s:iscode = 0
            endif
        elseif s:iscode == 0
            " 空行には行末空白なし
            .s/\v(\S\zs(\s{,1})|(\s{3,}))$/  /e
        endif
        let s:cursorline +=1
    endwhile
    call setpos('.', s:tmppos) " cursorの位置を戻す
endfunction
autocmd vimrc BufWritePre *.md :call MarkdownEOLTwoSpace()

" ----設定の編集--------------------------------------------------
nnoremap <F2> :<C-u>edit ~/dotfiles/vim/VimCheatSheet.md<CR>
nnoremap <F5> :<C-u>source $MYVIMRC<CR>
nnoremap <F6> :<C-u>edit $MYVIMRC<CR>
nnoremap <F7> :<C-u>edit ~/dotfiles/vim/dein.toml<CR>
nnoremap <F8> :<C-u>edit ~/dotfiles/vim/dein_lazy.toml<CR>
autocmd vimrc FileType help,quickrun nnoremap <buffer> q <C-w>c

" ----その他------------------------------------------------------
" <Space><CR>で上、Shift+Ctrl+Enterで下に空行挿入
nnoremap <Space><CR> mzo<ESC>`z:delmarks z<CR>
nnoremap  mzO<ESC>`z:delmarks z<CR>
" InsertModeでccc を入力し、エスケープでコメント線
inoreabbrev <expr> ccc repeat('-', 70 - virtcol('.'))
set noswapfile " ファイル編集中にスワップファイルを作らない
set hidden " 未保存ファイルが有っても別のファイルを開ける
set wildmenu  "コマンドモードの補完
set history=1000 " CommandHistoryを増やす
" Previewはいらない
set completeopt=menuone
autocmd vimrc FileType text,qf,quickrun setlocal wrap
set mouse=a
set ttimeoutlen=100 " ESCしてから挿入モード出るまでの時間を短縮
" 押し間違え多すぎだし使わないのでマッピング
imap <C-@> <C-[>
set helplang=ja,en


" --見た目系------------------------------------------------------
" ----cursor------------------------------------------------------
syntax on "コードの色分け
set title "編集中のファイル名表示
set number "行番号の表示
set nowrap " 折り返さない
set showmatch "括弧入力時に対応括弧表示
set colorcolumn=88 "カラムラインを引く(Pythonのformatter'black'基準)
set whichwrap=b,s,h,l,[,],<,>,~ "行末から次の行へ移動できる
filetype plugin on
set list "空白文字の可視化
" Tabは2文字必要
" 行末スペース、改行記号
" ウィンドウ幅狭いときの省略での文字表示*2、不可視のスペースを表す
set listchars=tab:\ \ ,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set display=lastline

" ----cursorの形をモードで変化(ターミナルによる)------------------
if has('vim_starting') " reloadableにするため
    " 挿入モード時に点滅の縦棒タイプのcursor
    let &t_SI .= "\e[5 q"
    " ノーマルモード時に非点滅のブロックタイプのcursor
    let &t_EI .= "\e[2 q"
    " 置換モード時に非点滅の下線タイプのcursor
    let &t_SR .= "\e[4 q"
endif

" ----折りたたみやカーソル位置を保存------------------------------
autocmd vimrc BufWritePost * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
autocmd vimrc BufRead * if expand('%') != '' && &buftype !~ 'nofile' | silent loadview | endif
set viewoptions=cursor,folds

" ----新しいwindowは下や右に開く----------------------------------
set splitbelow
set splitright
set winwidth=30
set winminwidth=30
set noequalalways
set belloff=all


" dein Scripts-----------------------------------------------------
let s:dein_path = expand('$HOME/.vim/dein')
let s:dein_repo_path = s:dein_path . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github からclone
if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_path)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_path
    endif
    execute 'set runtimepath^=' . fnamemodify(s:dein_repo_path, ':p')
endif

if dein#load_state(s:dein_path)
    call dein#begin(s:dein_path)

    let g:config_dir  = expand('$HOME/dotfiles/vim')
    let s:toml        = g:config_dir . '/dein.toml'
    let s:lazy_toml   = g:config_dir . '/dein_lazy.toml'

    call dein#load_toml(s:toml,      {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})

    " Required:
    call dein#end()
    call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
    call dein#install()
endif

" End dein Scripts------------------------------------------------


