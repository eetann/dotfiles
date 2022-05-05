# 展開------------------------------------------------------------
# Gスペース のように入力したら、勝手に | grep に置き換えてくれる
setopt extended_glob
typeset -A abbreviations
abbreviations=(
    "G"    "| grep"
    "X"    "| xargs"
    "T"    "| tail"
    "C"    "| cat"
    "W"    "| wc"
    "A"    "| awk"
    "S"    "| sed"
    "E"    "2>&1 > /dev/null"
    "N"    "> /dev/null"
    "DC"   "docker-compose"
    "CD"   "&& cd \$_"
    "CL"   "| clip.exe"
    "TREE" "tree -a -I '.git|node_modules|dist' --charset unicode"
)

magic-abbrev-expand() {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
    zle self-insert
}

no-magic-abbrev-expand() {
    LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand

# プラグインによる関数--------------------------------------------
# z ×fzf
function fz() {
    local fzf_command="fzf"
    if type fzf-tmux > /dev/null; then
        fzf_command="fzf-tmux -p 80%"
    fi
    fzf_command+=" --preview '$FZF_PREVIEW'"
    # zの出力の先頭12文字の頻度情報を使ってソートし、fzfに渡すときは削る
    local res=$(z | sort -rn | cut -c 12- | eval $fzf_command)
    if [ -n "$res" ]; then
        BUFFER+="cd $res"
        zle accept-line
    else
        return 1
    fi
}
zle -N fz
bindkey '^xz' fz

function fghq() {
    local fzf_command="fzf"
    if type fzf-tmux > /dev/null; then
        fzf_command="fzf-tmux -p 80%"
    fi
    local preview="bat --color=always --style=header,grid --line-range :100 $(ghq root)/{}/README.*"
    fzf_command+=" --preview '$preview'"

    local res=$(ghq list | eval $fzf_command)
    if [ -n "$res" ]; then
        BUFFER+="cd $(ghq root)/$res"
        zle accept-line
    else
        return 1
    fi
}
zle -N fghq
bindkey '^xg' fghq

function ghq-new() {
local root=`ghq root`
local user=`git config --get github.user`
if [ -z "$user" ]; then
    echo "you need to set github.user."
    echo "git config --global github.user YOUR_GITHUB_USER_NAME"
    return 1
fi
local name=$1
local repo="$root/github.com/$user/$name"
if [ -e "$repo" ]; then
    echo "$repo is already exists."
    return 1
fi
git init $repo
cd $repo
sed -e "s/Awesome-name/${name}/" ~/dotfiles/vim/template/markdown/base-readme.md > README.md
git add .
}

function my_fzf_completion() {
    # 入力をスペースで区切って配列に
    local ary=(`echo $LBUFFER`)
    local query
    local prebuffer
    # 単語を入力途中ならそれをクエリにする
    if [[ "${LBUFFER: -1}" == " " ]]; then
        query=""
        # 最後のスペースは削除するので配列の方
        prebuffer=$ary
    else
        query=${ary[-1]}
        prebuffer=${ary[1,-2]}
    fi
    # fzfでファイルを選択
    # テキストファイル以外をプレビュー
    # ASCIIは変換して表示
    local fzf_command="fzf"
    if type fzf-tmux > /dev/null; then
        fzf_command="fzf-tmux -p 80%"
    fi
    fzf_command+=" --query '$query' --preview '$FZF_PREVIEW'"
    selected=$(eval $FZF_FIND_FILE | sed "s/^\.\///" | eval $fzf_command)
    # ファイルを選択した場合のみバッファを更新
    if [[ -n "$selected" ]]; then
        # 改行をスペースに置換
        selected=$(tr '\n' ' ' <<< "$selected")
        BUFFER="${prebuffer} ${selected}"
    fi
    # カーソル位置を行末にして更新
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N my_fzf_completion
bindkey "^k" my_fzf_completion
