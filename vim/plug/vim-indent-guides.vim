UsePlugin 'vim-indent-guides'
" インデントの深さを可視化(要tabstop&shiftwidth設定)

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level = 2
hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=darkgrey
