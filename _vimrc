set encoding=utf-8
scriptencoding utf-8
set ambiwidth=double " □や○文字が崩れる問題を解決
set nocompatible

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END


autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown

"移動系
set scrolloff=3 "スクロールの余裕を確保する


"編集系

"----タブ設定
set tabstop=4 "タブ幅をスペース4つ分にする
set softtabstop=4 " 連続空白に対してTabやBackSpaceでカーソルが動く幅
set autoindent    " 改行時に前の行のインデントを継続する
set smartindent   " 改行時に入力された行の末尾に合わせて次行のインデントを増減
set shiftwidth=4  " smartindentでずれる幅

"----文字列検索
set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch " 検索結果をハイライト
" ESCキー2度押しでハイライトの切り替え
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>

set wildmenu  "コマンドモードの補完

"----コピペ
set clipboard=unnamed,autoselect " ヤンク&ペーストをクリップボード利用

set nrformats= "数増減は10進数で扱う

"----インサートモードのためのIMEの制御(Tera Termのみ?)
" let &t_SI .= "\e[<r" " 挿入入時、前回のIME状態復元
" let &t_EI .= "\e[<s\e[<0t" " 挿入出時、現在のIME状態を記録&IMEオフ
" let &t_te .= "\e[<0t\e[<s" " Vim終了時、IME無効&IMEを無効状態として記録
" set ttimeoutlen=100 " ESCしてから挿入モード出るまでの時間を短縮

"見た目系
"----カーソル
syntax on "コードの色分け
set title "編集中のファイル名表示
set number "行番号の表示
set showmatch "括弧入力時に対応括弧表示
set colorcolumn=80 "カラムラインを引く
set whichwrap=b,s,h,l,[,],<,>,~ "行末から次の行へ移動できる
filetype plugin on
set list "空白文字の可視化
"行末スペース、改行記号
"ウィンドウ幅狭いときの省略での文字表示*2、不可視のスペースを表す
set listchars=trail:-,eol:↲,extends:»,precedes:«,nbsp:%

"----ステータスラインの表示内容強化(lightlineに必要)
set laststatus=2 " ステータスラインを常に表示
set showmode " 現在のモードを表示
set showcmd " 打ったコマンドをステータスラインの下に表示
set ruler " ステータスラインの右側にカーソルの現在位置を表示する

set noswapfile " ファイル編集中にスワップファイルを作らない

"----カーソルの形をモードで変化
if has('vim_starting')
    " 挿入モード時に非点滅の縦棒タイプのカーソル
    let &t_SI .= "\e[6 q"
    " ノーマルモード時に非点滅のブロックタイプのカーソル
    let &t_EI .= "\e[2 q"
    " 置換モード時に非点滅の下線タイプのカーソル
    let &t_SR .= "\e[4 q"
endif


"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

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

  let g:config_dir  = expand('$HOME/.vim/dein/userconfig')
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

"End dein Scripts-------------------------

