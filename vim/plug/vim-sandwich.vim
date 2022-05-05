UsePlugin 'vim-sandwich'
" 括弧関連便利になる

let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
let g:sandwich#recipes += [
\ {'buns': ['（', '）'], 'input': ['jb'] },
\ {'buns': ['（', '）'], 'input': ['j('] },
\ {'buns': ['（', '）'], 'input': ['j)'] },
\ {'buns': ['（', '）'], 'input': ['j8'] },
\ {'buns': ['（', '）'], 'input': ['j9'] },
\ {'buns': ['［', '］'], 'input': ['j['] },
\ {'buns': ['［', '］'], 'input': ['j['] },
\ {'buns': ['［', '］'], 'input': ['jB'] },
\ {'buns': ['｛', '｝'], 'input': ['j}'] },
\ {'buns': ['｛', '｝'], 'input': ['j{'] },
\ {'buns': ['＜', '＞'], 'input': ['j<'] },
\ {'buns': ['＜', '＞'], 'input': ['j>'] },
\ {'buns': ['＜', '＞'], 'input': ['ja'] },
\ {'buns': ['≪', '≫'], 'input': ['jA'] },
\ {'buns': ['「', '」'], 'input': ['jk'] },
\ {'buns': ['『', '』'], 'input': ['jK'] },
\ {'buns': ['〈', '〉'], 'input': ['jy'] },
\ {'buns': ['《', '》'], 'input': ['jY'] },
\ {'buns': ['【', '】'], 'input': ['jr'] },
\ {'buns': ['【', '】'], 'input': ['js'] },
\ {'buns': ['〔', '〕'], 'input': ['jt'] },
\]
