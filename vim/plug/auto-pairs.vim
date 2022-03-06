UsePlugin 'jiangmiao/auto-pairs'
" 括弧などを入力したときの挙動をスマートに補完

let g:AutoPairsFlyMode = 1
autocmd vimrc Filetype tex let b:AutoPairs = deepcopy(g:AutoPairs)
autocmd vimrc Filetype tex let b:AutoPairs['$'] = '$'
