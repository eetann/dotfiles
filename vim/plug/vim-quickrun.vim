UsePlugin 'vim-quickrun'
" その場で実行できる

set errorformat=%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
let g:quickrun_config = {}
let g:quickrun_config = {
    \ "_":{
    \ 'runner'    : 'job',
    \ 'runner/terminal/into':1,
    \ 'outputter' : 'error',
    \ 'outputter/error/success' : 'buffer',
    \ 'outputter/error/error'   : 'quickfix',
    \ 'outputter/buffer/close_on_empty' : 1,
    \ 'outputter/buffer/into':1,
    \ 'outputter/buffer/split'  :
        \ '%{winwidth(0) * 2 < winheight(0) * 5 ? winheight(0)/4 : "vertical"}',
    \ 'outputter/quickfix/into':1,
    \ },
    \ 'markdown': {
    \ 'runner'    : 'vimscript',
    \ 'exec':'%c %a',
    \ 'command': ":call",
    \ 'args': 'My_opens()',
    \ 'outputter':'null',
    \ },
    \ 'html': {
    \ 'runner'    : 'vimscript',
    \ 'exec':'%c %a',
    \ 'command': ":call",
    \ 'args': 'My_opens()',
    \ 'outputter':'null',
    \ },
    \ 'tex': {
    \ 'command': 'latexmk',
    \ 'args':'-pvc',
    \ 'exec':'%c %a %s',
    \ },
    \ }
" qでquickfixを閉じる
autocmd vimrc FileType qf nnoremap <silent><buffer>q :quit<CR>
" normal or visual modeのとき <leader> + r で保存してからquickrunの実行
let g:quickrun_no_default_key_mappings = 1
nnoremap <leader>r :write<CR>:QuickRun -mode n<CR>
nnoremap <leader>R :write<CR>:QuickRun -runner terminal<CR>
xnoremap <leader>r :<C-U>write<CR>gv:QuickRun -mode v<CR>
" <C-c> でquickrunを停止
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
command! -nargs=+ -complete=command Capture QuickRun -type vim -src <q-args>
if has('nvim')
  " Use 'neovim_job' in Neovim
  let g:quickrun_config._.runner = 'neovim_job'
elseif exists('*ch_close_in')
  " Use 'job' in Vim which support job feature
  let g:quickrun_config._.runner = 'job'
endif
