# Vim cheat sheat  

| My<leader>       | <Space> |  
|------------------|---------|  
| 長いのでMLで表記 |         |  

# Original Vim  
| Mode   | Map           | Description                               | Original        |  
| ------ | ------------- | ----------------------------------------- | --------------- |  
| n      | o             | 下に行増やしてinsertMode                  |                 |  
| n      | O             | 上に行増やしてinsertMode                  |                 |  
| n      | I             | cursor行頭でInsertMode                    |                 |  
| nv     | >>            | indent深くする                            |                 |  
| nv     | <<            | indent浅くする                            |                 |  
| n      | <C-a>         | cursorの数字を増やす                      |                 |  
| n      | <C-x>         | cursorの数字を減らす                      |                 |  
| n      | zz            | cursor行を中央にして描画                  |                 |  
| i      | <C-r>= 1+1    | 計算結果を入力                            |                 |  
| nv     | D             | cursorから行末まで削除                    | delete          |  
| nv     | x             | cursorの文字を削除(Delete)                |                 |  
| nv     | X             | cursorの前の文字を削除(BackSpace)         |                 |  
| nv     | C             | cursorから行末までを削除してInsertMode    |                 |  
| n      | cl(本当はs)   | cursorの文字を削除してInsertMode          |                 |  
| n      | S             | 行を削除してInsertMode                    | Substitute      |  
| n      | r             | 文字を置き換え                            | replace         |  
| n      | R             | 単語を置き換え                            | Replace         |  
| n      | :bd           | バッファを閉じる                          | BufferDelete    |  
| n      | xp            | 2文字の入れ替え(前者にcursor)             |                 |  
| n      | q:            | Command History                           |                 |  
| n      | ea            | 単語の後ろに追記                          |                 |  
| n      | ggVG          | 全選択                                    |                 |  
| n      | g;            | 直前に変更した箇所にジャンプ              | go              |  
| n      | "%p           | 編集しているファイル名を貼り付け          |                 |  
| n      | qa            | aレジスタにマクロ記録開始                 |                 |  
| n      | q             | マクロ保存                                |                 |  
| n      | @a            | aレジスタのマクロを実行                   |                 |  
| v      | o             | 選択範囲のもう一方の端点に移動            |                 |  
| n      | <C-z>         | vimを一時停止してTerminalに移動           |                 |  
| term   | fg            | Terminalからvimに戻る                     |                 |  
| 補完   | <C-p>         | 前の候補へ                                | previous        |  
| 補完   | <C-n>         | 次の候補へ                                | next            |  
| 補完   | <C-y>         | 候補を選択                                | yes             |  
| i      | <C-r>reg      | registerを入力してペースト(0がヤンク用)   | register        |  
| i      | <C-t>         | indent深くする                            |                 |  
| i      | <C-d>         | indent浅くする                            | delete          |  
| i      | <C-h>         | cursorの前の文字を削除(BackSpace)         |                 |  
| i      | <C-u>         | cursorの前を全て削除                      |                 |  
| i      | <C-y>         | cursorより一行上の文字を挿入              |                 |  
| n      | :sp           | ウィンドウを横に分割                      | split           |  
| n      | :vs           | ウィンドウを縦に分割                      | verticalSplit   |  
| n      | d$            | cursor位置から行末まで削除                | delete          |  
| n      | d%            | 括弧を中身ごと削除                        | delete          |  
| n      | +             | 下の行の先頭へ                            |                 |  
| n      | -             | 上の行の先頭へ                            |                 |  
| n      | <C-u>         | 半画面上へ                                | up              |  
| n      | <C-d>         | 半画面下へ                                | down            |  
| n      | <C-b>         | 一画面上へ                                | BackWards       |  
| n      | <C-f>         | 一画面下へ                                | Forwards        |  
| n      | ge            | 前の単語の末尾へ                          |                 |  
| term   | <C-w><C-w>    | windowの切り替え                          |                 |  
| term   | <C-w>:q       | windowを閉じる                            |                 |  
| term   | <C-w>N        | TerminalNormalModeへ                      |                 |  
| v      | gQ            | Exコマンドを連続で使用                    |                 |  
| v      | view          | Exコマンドを連続使用からVisualModeへ      |                 |  
| v      | visual        | Exコマンドを連続使用からVisualModeへ      |                 |  
| cmd    | :set 何か?    | optionの設定値を確認                      | question        |  
| n      | <C-]>         | カーソル下の項目に飛ぶ                    |                 |  
| n      | <C-t>         | 飛ぶ前に戻る                              |                 |  
|  

# From my vimrc  
| Mode   | Map      | Description                  | Original             |  
| ------ | -------- | ---------------------------- | -------------------- |  
| v      | *        | 選択範囲の文字列を検索       |                      |  
| n      | ss       | 水平分割                     | :splite              |  
| n      | sv       | 垂直分割                     | :vsplite             |  
| n      | sh       | window間を左に移動           | <C-w>h               |  
| n      | sj       | window間を下に移動           | <C-w>j               |  
| n      | sk       | window間を上に移動           | <C-w>k               |  
| n      | sl       | window間を右に移動           | <C-w>l               |  
| n      | sw       | window間を次に移動           | <C-w>w               |  
| n      | sr       | windowを回転                 | <C-w>r               |  
| n      | sq       | windowを閉じる               | :q                   |  
| n      | sQ       | bufferを閉じる               | :bd                  |  
| t      | sf       | TernimalMode(fish)開始       |                      |  
| t      | <C-q>    | TernimalModebufferごと終了   |                      |  


# vim-surround  
| Mode   | Map     | Description                          | Original                   |  
| ------ | ------- | ------------------------------------ | -------------------------- |  
| n      | ds'     | 文を囲んでいる ' を消す              | delete surround            |  
| n      | di'     | ' で囲まれた部分を消す               | delete inside              |  
| n      | cs'"    | ' を "" に変更                       | change surroun             |  
| n      | ci'     | ' で囲まれた部分を消してInsertMode   | change inside              |  
| v      | S'      | 選択範囲を ' で囲む                  | Surrond                    |  
| n      | yss'    | 文を ' で囲む                        | yank surround sentence     |  
| n      | ysiw'   | cursorがある単語を ' で囲む          | yank surround inner word   |  
| n      | ci"     | "で囲まれた文字を修正                | change indide              |  
| n      | yi"     | "で囲まれた文字をコピー              | yank inside                |  
| n      | vi"     | "で囲まれた範囲を選択                | Visual-select inside       |  
|  

# vim-table-mode  (最初に:TableModeToggle)  
| Mode       | Map    | Description             | Original          |  
|------------|--------|-------------------------|-------------------|  
| n     | ML-tm  | TabaleModeにトグル      | TableMode         |  
| insert     | ┃     | 区切りを入れて自動調節  | Pipeline          |  
| insert     | ┃┃   | 行間の区切り            | Pipeline          |  
| visual     | ML-tt  | カンマ区切りをTableに   | ToTable           |  
| Tableize/, |        | デリミタ区切りをTableに |                   |  
| n     | ML-tdc | 列を削除                | TableDeleteColumn |  

# plasticboy/vim-markdown  
| Mode | Map | Description           | Original |  
|------|-----|-----------------------|----------|  
| n    | zc  | cursorのfieldを閉じる | close    |  
| n    | za  | cursorのfieldを開ける |          |  
| n    | zM  | 全てのfieldを閉じる   |          |  
| n    | xR  | 全てのfieldを開ける   |          |  


# scrooloose/nerdcommenter  
| Mode | Map              | Description          | Original    |  
|------|------------------|----------------------|-------------|  
| nv   | <leader>cA       | 行末にコメントを挿入 | Comment + A |  
| nv   | <leader>c<Space> | コメントトグル       | Comment     |  

# quickrun  
| Mode   | Map    | Description                  | Original   |  
| ------ | ------ | ---------------------------- | ---------- |  
| nv     | ML-r   | 保存してからquickrunの実行   | run        |  

# vim-easymotion  
| Mode   | Map                  | Description                           | Original |  
|--------|----------------------|---------------------------------------|----------|  
| n | f<char><char>+<char> | f + 2文字で画面全体を検索してジャンプ |          |  


# vim-easy-align  
| Mode | Map             | Description                  | Original                      |  
|------|-----------------|------------------------------|-------------------------------|  
| n    | vipga=          | 段落を選択して=で整形        | visual-select inner paragraph |  
| v    | ga<Enter><char> | 選択範囲を指定した文字で整形 |  

# dein.vim  
call map(dein#check_clean(), "delete(v:val, 'rf')")  
call dein#recache_runtimepath()  

# その他  
表記で、<C-a>と<C-A>のように、Cとの組み合わせでは、大文字と小文字の区別はない  
関数の定義で、function!のように、後ろに!をつけると、既存の関数を上書きする。  
vimrcやdein.tomlの再読みのためにつけたほうがいい  

コメントの線  
inoreabbrev <expr> dl repeat('-', 80 - col('.')  

a"やi'などは、テキストオブジェクト  



