# Vim cheat sheat  

| My<leader>       | <Space> |  
|------------------|---------|  
| 長いのでMLで表記 |         |  

# Original Vim  
| Mode     | Map        | Description                                   | Original   |  
|----------|------------|-----------------------------------------------|------------|  
| nv       | >>         | indent深くする                                |            |  
| nv       | <<         | indent浅くする                                |            |  
| n        | <C-a>      | cursorの数字を増やす                          |            |  
| n        | <C-x>      | cursorの数字を減らす                          |            |  
| n        | zz         | cursor行を中央にして描画                      |            |  
| i        | <C-r>= 1+1 | 計算結果を入力                                |            |  
| nv       | D          | cursorから行末まで削除                        | delete     |  
| nv       | x          | カーソルの文字を削除(Deleteキーみたい)        |            |  
| nv       | X          | カーソルの前の文字を削除(BackSpaceキーみたい) |            |  
| nv       | C          | cursorから行末までを削除して挿入モード        |            |  
| n        | s          | カーソルの文字を削除して挿入モード            | substitute |  
| n        | S          | 行を削除して挿入モード                        | Substitute |  
| n        | r          | 文字を置き換え                                | replace    |  
| n        | R          | 単語を置き換え                                | Replace    |  
| n        | :bd        | バッファを閉じる                              |            |  
| n        | xp         | 2文字の入れ替え(前者にカーソル)               |            |  
| n        | q:         | Command History                               |            |  
| n        | ea         | 単語の後ろに追記                              |            |  
| n        | ggVG       | 全選択                                        |            |  
| n        | g;         | 直前に変更した箇所にジャンプ                  | go         |  
| n        | "%p        | 編集しているファイル名を貼り付け              |            |  
| n        | qa         | aレジスタにマクロ記録開始                     |            |  
| n        | q          | マクロ保存                                    |            |  
| n        | @a         | aレジスタのマクロを実行                       |            |  
| v        | o          | 選択範囲のもう一方の端点に移動                |            |  
| n        | <C-z>      | vimを一時停止してTerminalに移動               |            |  
| terminal | fg         | Terminalからvimに戻る                         |            |  



# From my vimrc  
| Mode | Map | Description              | Original |  
|------|-----|--------------------------|----------|  
| n    | o   | 下に行増やしてinsertMode |          |  
| n    | O   | 上に行増やしてinsertMode |          |  
| v    | *   | 選択範囲の文字列を検索   |          |  
|  


# vim-surround  
| Mode | Map   | Description                        | Original                 |  
|------|-------|------------------------------------|--------------------------|  
| n    | ds'   | 文を囲んでいる ' を消す            | delete surround          |  
| n    | di'   | ' で囲まれた部分を消す             | delete inside            |  
| n    | cs'"  | ' を "" に変更                     | change surroun           |  
| n    | ci'   | ' で囲まれた部分を消してInsertMode | change inside            |  
| v    | S'    | 選択範囲を ' で囲む                | Surrond                  |  
| n    | yss'  | 文を ' で囲む                      | yank surround sentence   |  
| n    | ysiw' | カーソルがある単語を ' で囲む      | yank surround inner word |  
| n    | ci"   | "で囲まれた文字を修正              | change indide            |  
| n    | yi"   | "で囲まれた文字をコピー            | yank inside              |  
| n    | vi"   | "で囲まれた範囲を選択              | Visual-select inside     |  
|  

# vim-table-mode  (最初に:TableModeToggle)  
| Mode       | Map    | Description             | Original          |  
|------------|--------|-------------------------|-------------------|  
| normal     | ML-tm  | TabaleModeにトグル      | TableMode         |  
| insert     | ┃     | 区切りを入れて自動調節  | Pipeline          |  
| insert     | ┃┃   | 行間の区切り            | Pipeline          |  
| visual     | ML-tt  | カンマ区切りをTableに   | ToTable           |  
| Tableize/, |        | デリミタ区切りをTableに |                   |  
| normal     | ML-tdc | 列を削除                | TableDeleteColumn |  

# plasticboy/vim-markdown  
| Mode   | Map | Description           | Original |  
|--------|-----|-----------------------|----------|  
| normal | zc  | cursorのfieldを閉じる | close    |  
| normal | za  | cursorのfieldを開ける |          |  
| normal | zM  | 全てのfieldを閉じる   |          |  
| normal | xR  | 全てのfieldを開ける   |          |  


# scrooloose/nerdcommenter  
| Mode | Map              | Description          | Original    |  
|------|------------------|----------------------|-------------|  
| nv   | <leader>cA       | 行末にコメントを挿入 | Comment + A |  
| nv   | <leader>c<Space> | コメントトグル       | Comment     |  

# quickrun  
| Mode | Map  | Description                | Original |  
|------|------|----------------------------|----------|  
| nv   | ML-r | 保存してからquickrunの実行 | run      |  

# vim-easymotion  
| Mode   | Map                  | Description                           | Original |  
|--------|----------------------|---------------------------------------|----------|  
| normal | f<char><char>+<char> | f + 2文字で画面全体を検索してジャンプ |          |  


# vim-easy-align  
| Mode | Map             | Description                  | Original                      |  
|------|-----------------|------------------------------|-------------------------------|  
| n    | vipga=          | 段落を選択して=で整形        | visual-select inner paragraph |  
| v    | ga<Enter><char> | 選択範囲を指定した文字で整形 |  

#  
| Mode | Map | Description | Original |  
|------|-----|-------------|----------|  

#  
| Mode | Map | Description | Original |  
|------|-----|-------------|----------|  


