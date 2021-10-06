" 文字関連の設定
set encoding=utf-8
set fileencodings=utf-8
" set fileencodings=utf-8,sjis " この順番でMATLABとそれ以外がうまくいった
scriptencoding utf-8
set ambiwidth=double " □や○文字が崩れる問題を解決
set nrformats= "数増減は10進数で扱う(<C-a>や<C-x>)
set backspace=indent,eol,start

" ----reset augroup-----------------------------------------------
" 再読込時に2度設定しないように、初期化
augroup vimrc
    autocmd!
augroup END

" ----移動系------------------------------------------------------
set scrolloff=3 " 上下のスクロールの余裕を確保する

"---- コピペ関連--------------------------------------------------
set clipboard&
set clipboard^=unnamedplus
set clipboard-=autoselect

" ----タブ設定----------------------------------------------------
set expandtab " インデントをタブの代わりにスペース
set tabstop=4 "タブ幅をスペース4つ分にする
set softtabstop=4 " 連続空白に対してTabやBackSpaceでcursorが動く幅
set autoindent    " 改行時に前の行のintentを継続する
set smartindent   " 改行時に入力された行の末尾に合わせて次行のintentを増減
set shiftwidth=4  " smartindentでずれる幅
" \入力時自動インデント阻止
let g:vim_indent_cont = 0

" ----文字列検索--------------------------------------------------
set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set shortmess-=S " 検索時に検索件数メッセージを表示
" html記述に合わせてファイルの相対パスが/始まりでも認識できるようにする
set includeexpr=substitute(v:fname,'^\\/','','') 

" ----grepの設定
" 日本語grepする。要go get取得
set grepprg=jvgrep
" grepはquickfixで開く
autocmd vimrc QuickFixCmdPost *grep* cwindow
let Grep_Skip_Dirs = '.svn .git'

" ----その他------------------------------------------------------
set noswapfile " ファイル編集中にスワップファイルを作らない
set hidden " 未保存ファイルが有っても別のファイルを開ける
set wildmenu  "コマンドモードの補完
set history=1000 " CommandHistoryを増やす
" Previewはいらない
if !has('nvim')
    set completeopt=menuone,popup
endif
set mouse=a
set ttimeoutlen=100 " ESCしてから挿入モード出るまでの時間を短縮
set helplang=ja,en
set keywordprg=:help
set formatoptions-=ro
set formatoptions+=Mj

" --見た目系------------------------------------------------------
" ----cursor------------------------------------------------------
set title "編集中のファイル名表示
set relativenumber " 相対的な行番号の表示
set number " 現在の行番号の表示
set nowrap " 折り返さない
set showmatch "括弧入力時に対応括弧表示
set colorcolumn=88 "カラムラインを引く(Pythonのformatter'black'基準)
set whichwrap=b,s,h,l,[,],<,>,~ "行末から次の行へ移動できる
set signcolumn=yes
set list "空白文字の可視化
" Tabは2文字必要
" 行末スペース、改行記号
" ウィンドウ幅狭いときの省略での文字表示*2、不可視のスペースを表す
set listchars=tab:\|\ ,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set display=lastline

" ----折りたたみやカーソル位置を保存------------------------------
" set viewoptions=cursor,folds
" autocmd vimrc BufWritePost * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
" autocmd vimrc BufRead * if expand('%') != '' && &buftype !~ 'nofile' | silent loadview | endif
autocmd vimrc BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal g`\"" | endif

" ----新しいwindowは下や右に開く----------------------------------
set splitbelow
set splitright
set winwidth=30
set winminwidth=30
set noequalalways
set belloff=all

" 設定ファイルの読み込み------------------------------------------
call map(sort(split(glob('~/dotfiles/vim/*.vim'), '\n')),
\ {->[execute('exec "so" v:val')]})
" 参考
" echo map([1, 2, 3], {-> v:val + v:val })
" {args -> expr1} lambda

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

    call dein#load_toml(g:config_dir . '/dein.toml', {'lazy': 0})
    call dein#load_toml(g:config_dir . '/dein_completion.toml', {'lazy': 1})
    call dein#load_toml(g:config_dir . '/dein_textobj.toml', {'lazy': 1})
    call dein#load_toml(g:config_dir . '/dein_filetype.toml', {'lazy': 1})
    call dein#load_toml(g:config_dir . '/dein_lazy.toml', {'lazy': 1})

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
