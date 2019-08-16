# pacman や yaourt のパッケージリストも補完するようになる  
zplug "zsh-users/zsh-completions"  

# git の補完を効かせる  
# 補完＆エイリアスが追加される  
zplug "plugins/git",   from:oh-my-zsh  
zplug "peterhurford/git-aliases.zsh"  

# 入力途中に候補をうっすら表示  
zplug "zsh-users/zsh-autosuggestions"  

# コマンドを種類ごとに色付け  
zplug "zsh-users/zsh-syntax-highlighting", defer:2  

# ヒストリの補完を強化する  
zplug "zsh-users/zsh-history-substring-search", defer:3  

# 本体（連携前提のパーツ）  
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf  
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux  
# コマンド化するときに file: でリネームできる（この例では fzf-bin を fzf にしてる）  
zplug "junegunn/fzf-bin", \  
    as:command, \  
    from:gh-r, \  
    file:fzf  

# fzf でよく使う関数の詰め合わせ  
zplug "mollifier/anyframe"  

# ディレクトリ移動を高速化（fzf であいまい検索）  
zplug "b4b4r07/enhancd", use:init.sh  

# git のローカルリポジトリを一括管理（fzf でリポジトリへジャンプ）  
zplug "motemen/ghq", as:command, from:gh-r  


