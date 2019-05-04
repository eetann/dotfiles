" 文字関連の設定
set encoding=utf-8
scriptencoding utf-8
set ambiwidth=double " □や○文字が崩れる問題を解決
set nrformats= "数増減は10進数で扱う

let mapleader = "\<Space>" " leaderキーの割当を変える
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;
nnoremap q; q:

" --reset augroup-----------------------------
"  再読込時に２度設定しないため、最初に消す
"  autocmdを使うときにはautocmd vimrc ゴニョゴニョと書く
augroup vimrc
  autocmd!
augroup END

" --移動系---------------------------------
set scrolloff=5 "スクロールの余裕を確保する
nnoremap j gj
nnoremap k gk
map H ^
map L $
" sはclで代用する
nnoremap s <Nop>
" ----画面移動
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
" 分割(水平&垂直)
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
" nnoremap sq :<C-u>q<CR>
" バッファを閉じる
nnoremap sq :<C-u>bd<CR>
nnoremap sQ :<C-u>bd!<CR>
" InsertModeでカーソル移動
inoremap <C-b> <left>
inoremap <C-f> <right>
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

" --編集系---------------------------------
" ----コピペ関連
" VisualModeで置換対象ペースト時のヤンク入れ替えを防ぐ
xnoremap <expr> p 'pgv"'.v:register.'ygv<esc>'
set clipboard=unnamedplus " ヤンク&ペーストをクリップボード利用
" ペーストした範囲をvisualModeで選択
nnoremap <expr> sp '`[' . strpart(getregtype(), 0, 1) . '`]'
" 全選択
nnoremap s<C-a> ggVG

" ----改行時自動コメントオフ
set formatoptions=cql
" ----タブ設定
set tabstop=4 "タブ幅をスペース4つ分にする
set softtabstop=4 " 連続空白に対してTabやBackSpaceでcursorが動く幅
set autoindent    " 改行時に前の行のintentを継続する
set smartindent   " 改行時に入力された行の末尾に合わせて次行のintentを増減
set shiftwidth=4  " smartindentでずれる幅

" ----文字列検索
set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
" ESCキー2度押しでハイライトの切り替え
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

" ----grepの設定
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

" ----vimrcの編集
nnoremap <F2> :<C-u>edit ~/dotfiles/vim/VimCheatSheet.md<CR>
nnoremap <F5> :<C-u>source $MYVIMRC<CR>
nnoremap <F6> :<C-u>edit $MYVIMRC<CR>
nnoremap <F7> :<C-u>edit ~/dotfiles/vim/dein.toml<CR>
nnoremap <F8> :<C-u>edit ~/dotfiles/vim/dein_lazy.toml<CR>
autocmd vimrc FileType help,quickrun nnoremap <buffer> q <C-w>c

" ----その他
" <Space><CR>で上、Shift+Ctrl+Enterで下に空行挿入
nnoremap <Space><CR> mzo<ESC>`z:delmarks z<CR>
nnoremap  mzO<ESC>`z:delmarks z<CR>
" InsertModeでcccを入力し、エスケープでコメント線
inoreabbrev <expr> ccc repeat('-', 70 - col('.'))
set spelllang=en,cjk " スペルチェックについて
set noswapfile " ファイル編集中にスワップファイルを作らない
set hidden " 未保存ファイルが有っても別のファイルを開ける
set wildmenu  "コマンドモードの補完
set history=1000 " CommandHistoryを増やす
set completeopt=menuone
autocmd vimrc FileType text,qf,quickrun setlocal wrap

" ----インサートモードのためのIMEの制御(Tera Termのみ?)
" let &t_SI .= "\e[<r" " 挿入入時、前回のIME状態復元
" let &t_EI .= "\e[<s\e[<0t" " 挿入出時、現在のIME状態を記録&IMEオフ
" let &t_te .= "\e[<0t\e[<s" " Vim終了時、IME無効&IMEを無効状態として記録
set ttimeoutlen=100 " ESCしてから挿入モード出るまでの時間を短縮


" --見た目系---------------------------------
" ----cursor
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

" ----cursorの形をモードで変化
if has('vim_starting') " reloadableにするため
	" 挿入モード時に点滅の縦棒タイプのcursor
	let &t_SI .= "\e[5 q"
	" ノーマルモード時に非点滅のブロックタイプのcursor
	let &t_EI .= "\e[2 q"
	" 置換モード時に非点滅の下線タイプのcursor
	let &t_SR .= "\e[4 q"
endif

" ----折りたたみ
autocmd vimrc BufWritePost * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
autocmd vimrc BufRead * if expand('%') != '' && &buftype !~ 'nofile' | silent loadview | endif
set viewoptions=cursor,folds

" ----新しいwindowは下や右に開く
set splitbelow
set splitright
" ターミナルモードでfishを開く
nnoremap st :belowright :terminal<CR>
" tnoremap <C-q> <C-w><C-c><C-w>:q!<CR>

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

"End dein Scripts-------------------------


