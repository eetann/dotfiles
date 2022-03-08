UsePlugin 'nvim-hlslens'
" searchをわかりやすく表示

function! s:set_hlsearch() abort
  if v:hlsearch == 1
    set nohlsearch
    execute 'HlSearchLensDisable'
  else
    set hlsearch
    execute 'HlSearchLensEnable'
  endif
endfunction

nnoremap <silent> <ESC><ESC> :call <SID>set_hlsearch()<CR>

lua << EOF
local kopts = {noremap = true, silent = true}

vim.api.nvim_set_keymap('n', 'n',
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', 'N',
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
EOF
