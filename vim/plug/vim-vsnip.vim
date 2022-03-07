UsePlugin 'vim-vsnip'
" snippet manager

" Expand or jump
imap <expr> <C-k> vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-k>'
smap <expr> <C-k> vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-k>'

" If you want to use snippet for multiple filetypes, you can `g:vsnip_filetypes` for it.
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']
let g:vsnip_snippet_dir = "~/dotfiles/vim/snippet"
