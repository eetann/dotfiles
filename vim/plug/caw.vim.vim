UsePlugin 'caw.vim'
" コメントアウトで便利

let g:caw_dollarpos_sp_left=' '
" TODO: コメントアウト時にカーソル位置を移動しない
nmap gc     <Plug>(caw:prefix)
xmap gc     <Plug>(caw:prefix)
nmap gcc    <Plug>(caw:hatpos:toggle)
nmap <C-_>  <Plug>(caw:hatpos:toggle)
xmap gcc    <Plug>(caw:hatpos:toggle)
nmap gci    <Plug>(caw:hatpos:comment)
nmap gcui   <Plug>(caw:hatpos:uncomment)
nmap gcI    <Plug>(caw:zeropos:comment)
nmap gcuI   <Plug>(caw:zeropos:uncomment)
nmap gca    <Plug>(caw:dollarpos:comment)
nmap gcua   <Plug>(caw:dollarpos:uncomment)
xmap gcw    <Plug>(caw:wrap:comment)
nmap gco    <Plug>(caw:jump:comment-next)
nmap gcO    <Plug>(caw:jump:comment-prev)
nmap gct    <Plug>(caw:jump:comment-next)TODO:<Space>
nmap gcT    <Plug>(caw:jump:comment-prev)TODO:<Space>
nnoremap gcl :vimgrep /TODO:/j %<CR>
