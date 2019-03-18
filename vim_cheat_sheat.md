# Vim cheat sheat  

| My<leader>       | <Space> |  
|------------------|---------|  
| 長いのでMLで表記 |         |  

# Original Vim  
| Mode   | Map | Description      | Original |  
|--------|-----|------------------|----------|  
| normal |     |                  |          |  
| nv     | >>  | indent深くする   |          |  
| nv     | <<  | indent浅くする |          |  

# plasticboy/vim-markdown  
| Mode   | Map | Description           | Original |  
|--------|-----|-----------------------|----------|  
| normal | zc  | cursorのfieldを閉じる | close    |  
| normal | za  | cursorのfieldを開ける |          |  
| normal | zM  | 全てのfieldを閉じる   |          |  
| normal | xR  | 全てのfieldを開ける   |          |  

# vim-table-mode  (最初に:TableModeToggle)  
| Mode       | Map    | Description             | Original          |  
|------------|--------|-------------------------|-------------------|  
| normal     | ML-tm  | TabaleModeにトグル      | TableMode         |  
| insert     | ┃     | 区切りを入れて自動調節  | Pipeline          |  
| insert     | ┃┃   | 行間の区切り            | Pipeline          |  
| visual     | ML-tt  | カンマ区切りをTableに   | ToTable           |  
| Tableize/, |        | デリミタ区切りをTableに |                   |  
| normal     | ML-tdc | 列を削除                | TableDeleteColumn |  


# scrooloose/nerdcommenter  
| Mode | Map              | Description          | Original    |  
|------|------------------|----------------------|-------------|  
| nv   | <leader>cA       | 行末にコメントを挿入 | Comment + A |  
| nv   | <leader>c<Space> | コメントトグル       | Comment     |  

#  
| Mode | Map | Description | Original |  
|------|-----|-------------|----------|  

#  
| Mode | Map | Description | Original |  
|------|-----|-------------|----------|  



normal,w,,,  
normal,D,delete,行末まで削除,  
normal,x,,カーソルの文字を削除(Deleteキーみたい),  
normal,X,,カーソルの前の文字を削除(BackSpaceキーみたい),  
normal,s,substitute,カーソルの文字を削除して挿入モード,  
normal,S,Substitute,行を削除して挿入モード,  
normal,r,replace,文字を置き換え,  
normal,R,Replace,単語を置き換え,  
visual,o,,選択範囲のもう一方の端点に移動,  
normal,:bd,,バッファを閉じる,  
,:close,,,  
,ds',,文を囲んでいる ' を消す,vim-surround  
,di',,  ' で囲まれた部分を消す,vim-surround  
,"cs'""",,"  ' を "" に変更",vim-surround  
,ci',,"  ' で囲まれた部分を消して, インサートモードに入る",vim-surround  
,S',,ビジュアルモードで選択した部分を ' で囲む,vim-surround  
,yss',,文を ' で囲む,vim-surround  
,ysiw',,カーソルがある単語を ' で囲む,vim-surround  
normal,<leader>r,run,保存してからquickrunの実行,vim-quickrun  
visual,<leader>r,run,保存してからquickrunの実行,vim-quickrun  
normal,f<char><char>+<char>,,f + 2文字 で画面全体を検索してジャンプ,vim-easymotion  
,ggVG,,全選択,組み合わせ  
,vipga=,visual-select inner paragraph,パラグラフを選択して=で整形,vim-easy-align  
visual,ga<Enter><char>,,選択範囲を指定した文字で整形,vim-easy-align  
