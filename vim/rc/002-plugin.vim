function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" Install vim-plug if not found
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
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

if has('nvim')
  Plug 'nvim-lua/plenary.nvim' " nvim
  Plug 'nvim-telescope/telescope.nvim' " vim/plug/telescope.nvim.vim
  " vim/plug/nvim-lspconfig.vim
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer'
  Plug 'ray-x/lsp_signature.nvim' " signature help for insert mode
  Plug 'tami5/lspsaga.nvim'
  Plug 'jose-elias-alvarez/null-ls.nvim'

  " vim/plug/nvim-cmp.vim
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'onsails/lspkind-nvim'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip' " vim/plug/vim-vsnip.vim
  Plug 'hrsh7th/vim-vsnip-integ'
  Plug 'rafamadriz/friendly-snippets'
endif

Plug 'sainnhe/gruvbox-material' " vim/plug/gruvbox-material.vim
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nathanaelkane/vim-indent-guides' " vim/plug/vim-indent-guides.vim
Plug 'vim-airline/vim-airline' " vim/plug/vim-airline.vim
Plug 'vim-airline/vim-airline-themes' " ステータスラインのテーマ
Plug 'romgrk/barbar.nvim' " vim/plug/barbar.vim
Plug 'kevinhwang91/nvim-hlslens' " vim/plug/nvim-hlslens.vim
Plug 'petertriho/nvim-scrollbar' " vim/plug/nvim-scrollbar.vim

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
