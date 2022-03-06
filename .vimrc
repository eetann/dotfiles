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
if has('termguicolors')
  set termguicolors
endif
set background=dark

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
"
" 設定ファイルの読み込み------------------------------------------
call map(sort(split(glob('~/dotfiles/vim/*.vim'), '\n')),
\ {->[execute('exec "so" v:val')]})
" 参考
" echo map([1, 2, 3], {-> v:val + v:val })
" {args -> expr1} lambda

filetype plugin indent on
syntax enable
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

" vim-plug--------------------------------------------------------
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" Install vim-plug if not found
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  " silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  silent execute '!curl -fLo '.data_dir.
   \ '/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" Run PlugInstall if there are missing plugins
autocmd vimrc VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
 \| PlugInstall --sync | source $MYVIMRC
 \| endif

" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Declare the list of plugins.
Plug 'machakann/vim-highlightedyank' " vim/plug/vim-highlightedyank.vim
Plug 'kana/vim-textobj-user' " add textobj
  Plug 'osyo-manga/vim-textobj-multiblock',
  \ {'on': ['<Plug>(textobj-multiblock-']} " vim/plug/vim-textobj-multiblock.vim

Plug 'machakann/vim-swap', {'on': ['<Plug>(swap-']} " vim/plug/vim-swap.vim
Plug 'jiangmiao/auto-pairs' " vim/plug/auto-pairs.vim
Plug 'andymass/vim-matchup' " %を拡張
Plug 'machakann/vim-sandwich' " 括弧関連便利になる

Plug 'roxma/nvim-yarp', Cond(!has('nvim')) " nvim系に必要
Plug 'roxma/vim-hug-neovim-rpc', Cond(!has('nvim')) " nvim系に必要

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Plug 'honza/vim-snippets' " スニペット集
Plug 'Shougo/neosnippet-snippets' " スニペット集
Plug 'Shougo/neosnippet.vim' " vim/plug/neosnippet.vim.vim
Plug 'neoclide/coc.nvim', {'branch': 'release'} " vim/plug/coc.nvim.vim

Plug 'sainnhe/gruvbox-material' " vim/plug/gruvbox-material.vim
Plug 'nathanaelkane/vim-indent-guides' " vim/plug/vim-indent-guides.vim
Plug 'vim-airline/vim-airline' " vim/plug/vim-airline.vim
Plug 'vim-airline/vim-airline-themes' " ステータスラインのテーマ

Plug 'tyru/caw.vim', {'on': '<Plug>(caw:'} " vim/plug/caw.vim.vim
Plug 'tyru/open-browser.vim', 
  \ {'on': ['<Plug>(openbrowser-smart-search)', 'OpenBrowser']} " vim/plug/open-browser.vim.vim

Plug 'thinca/vim-quickrun' " vim/plug/vim-quickrun.vim
Plug 'lambdalisue/vim-quickrun-neovim-job' " quickrunをNeovimで使う

Plug 'mattn/vim-sonictemplate', {'on': ['Tem', 'Template']} " vim/plug/vim-sonictemplate.vim
Plug 'junegunn/vim-easy-align', {'on': '<Plug>(LiveEasyAlign)'} " vim/plug/vim-easy-align.vim
Plug 'bkad/CamelCaseMotion', {'on': '<Plug>CamelCaseMotion'} " vim/plug/CamelCaseMotion.vim
Plug 'delphinus/vim-auto-cursorline' " vim/plug/vim-auto-cursorline.vim
Plug 'kshenoy/vim-signature' " マーク位置の表示
Plug 'vim-jp/vimdoc-ja', {'for': 'help'} " 日本語ヘルプ
Plug 'simeji/winresizer' " vim/plug/winresizer.vim

Plug 'cespare/vim-toml', {'for': 'toml'} " TOMLのシンタックスハイライト
Plug 'mechatroner/rainbow_csv', {'for': 'csv'} " vim/plug/rainbow_csv.vim
" Plug 'leafOfTree/vim-vue-plugin', {'for': 'vue'} " 

" vim/plug/emmet-vim.vim
Plug 'mattn/emmet-vim',
    \ {'for': ['html', 'css', 'php', 'xml', 'javascript', 'vue', 'typescriptreact', 'react']}

Plug 'ap/vim-css-color', {'for': ['css']} " CSSの色付け

" vim/plug/vim-markdown.vim
Plug 'plasticboy/vim-markdown',
  \ {'for': ['markdown','md','mdwn','mkd','mkdn','mark']}

" テーブルの生成を補助?
Plug 'godlygeek/tabular',
  \ {'for': ['markdown','md','mdwn','mkd','mkdn','mark']}
" vim/plug/vim-table-mode.vim
Plug 'dhruvasagar/vim-table-mode',
  \ {'for': ['markdown','md','mdwn','mkd','mkdn','mark']}

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Load plugin settings
let s:plugs = get(s:, 'plugs', get(g:, 'plugs', {}))
function! FindPlugin(name) abort
  return has_key(s:plugs, a:name) ? isdirectory(s:plugs[a:name].dir) : 0
endfunction
command! -nargs=1 UsePlugin if !FindPlugin(<args>) | finish | endif
command! PU PlugUpdate | PlugUpgrade

let s:base_dir = expand('~/dotfiles/vim/')
execute 'set runtimepath+=' . fnamemodify(s:base_dir, ':p')
runtime! plug/*.vim
