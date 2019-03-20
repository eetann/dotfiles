set encoding=utf-8
scriptencoding utf-8
set ambiwidth=double " □や○文字が崩れる問題を解決
set nocompatible
set guifont=Cica:h11
set printfont=Cica:h8
let mapleader = "\<Space>" " leaderキーの割当を変える


" --reset augroup-----------------------------
augroup MyAutoCmd
  autocmd!
augroup END


" --移動系---------------------------------
set scrolloff=3 "スクロールの余裕を確保する

" --編集系---------------------------------
" ----コピペ関連
" VisualModeで置換対象ペースト時のヤンク入れ替えを防ぐ
xnoremap <expr> p 'pgv"'.v:register.'ygv<esc>'
set clipboard=unnamedplus " ヤンク&ペーストをクリップボード利用
" WSLの場合のコピペも他と同じように行えるよう設定(VcXsrv使ってるので無効に)
" if filereadable('/proc/sys/fs/binfmt_misc/WSLInterop')
"     autocmd TextYankPost * :call system('win32yank.exe -i', @")
"     nnoremap <silent>p :r !win32yank.exe -o<CR>
"     vnoremap <silent>p :r !win32yank.exe -o<CR>
" endif

" ----タブ設定
set tabstop=4 "タブ幅をスペース4つ分にする
set softtabstop=4 " 連続空白に対してTabやBackSpaceでカーソルが動く幅
set autoindent    " 改行時に前の行のインデントを継続する
set smartindent   " 改行時に入力された行の末尾に合わせて次行のインデントを増減
set shiftwidth=4  " smartindentでずれる幅

" ----文字列検索
set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch " 検索結果をハイライト
" ESCキー2度押しでハイライトの切り替え
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>
" カーソル下の単語をハイライトする
nnoremap <silent> <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
" *(前方)、#(後方)を押したら選択範囲を検索
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch()
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

" ----Markdownのための設定
function! MarkdownEOLTwoSpace()
	let s:tmppos = getpos(".") " カーソルの位置を記録しておく
	" 行末に改行のための空白2つのみを付与
	%s/\v(\S\zs(\s{,1})|(\s{3,}))$/  /e
	call setpos(".", s:tmppos) " カーソルの位置を戻す
endfunction
autocmd BufWritePre *.{md,mdwn,mkd,mkdn,mark*} :call MarkdownEOLTwoSpace()


" ----その他
" <Space><CR>で上、Shift+Ctrl+Enterで下に空行挿入
nnoremap <Space><CR> mzo<ESC>`z<Nul>dmz
nnoremap  mzO<ESC>`z<Nul>dmz
set nrformats= "数増減は10進数で扱う
set spelllang=en,cjk
set history=100 " CommandHistoryを増やす
set noswapfile " ファイル編集中にスワップファイルを作らない
set wildmenu  "コマンドモードの補完

" ----インサートモードのためのIMEの制御(Tera Termのみ?)
" let &t_SI .= "\e[<r" " 挿入入時、前回のIME状態復元
" let &t_EI .= "\e[<s\e[<0t" " 挿入出時、現在のIME状態を記録&IMEオフ
" let &t_te .= "\e[<0t\e[<s" " Vim終了時、IME無効&IMEを無効状態として記録
set ttimeoutlen=100 " ESCしてから挿入モード出るまでの時間を短縮


" --見た目系---------------------------------
" ----カーソル
syntax on "コードの色分け
set title "編集中のファイル名表示
set number "行番号の表示
set nowrap " 折り返さない
set showmatch "括弧入力時に対応括弧表示
set colorcolumn=88 "カラムラインを引く(Pythonのformatter'black'基準)
set whichwrap=b,s,h,l,[,],<,>,~ "行末から次の行へ移動できる
filetype plugin on
set list "空白文字の可視化
" Tabは\<Space>\<Space>と指定(2字必要)
" 行末スペース、改行記号
" ウィンドウ幅狭いときの省略での文字表示*2、不可視のスペースを表す
set listchars=tab:\ \ ,trail:-,eol:↲,extends:»,precedes:«,nbsp:%

" ----カーソルの形をモードで変化
if has('vim_starting')
	" 挿入モード時に点滅の縦棒タイプのカーソル
	let &t_SI .= "\e[5 q"
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


