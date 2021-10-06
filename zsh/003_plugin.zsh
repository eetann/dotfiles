source ~/.zinit/bin/zinit.zsh

# zinit のコマンド補完をロード
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# plugins --------------------------------------------------------
# `zinit light {plugin}`で読み込み
# その前に`zinit ice {option}`でオプションをつける
# blockf : プラグインの中で$fpathに書き込むのを禁止
zinit ice blockf
zinit light zsh-users/zsh-completions

zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

zinit light zdharma/fast-syntax-highlighting

# wait'n' : .zshrc が読み込まれて n 秒で読み込む
# nの前に!をつけると読み込み完了メッセージを非表示
zinit ice wait'!0'; zinit light rupa/z
zinit ice wait'!0'; zinit light zsh-users/zsh-history-substring-search

# as"program" : プラグインをsourceせず、$PATHに追加
zinit ice wait'!0' as"program"; zinit light arks22/tmuximum

# from"{hoge}"              : hogeからclone
# pick"hoge.zsh"            : $PATHに追加するファイルを指定
# multisrc"{hoge,fuga}.zsh" : 複数のファイルをsource
# id-as                     : ニックネーム
# atload                    : プラグインがロード後に実行
zinit ice wait"!0" from"gh-r" as"program"; zinit load junegunn/fzf-bin
zinit ice wait"!0" as"program" pick"bin/fzf-tmux"; zinit load junegunn/fzf
zinit ice wait"!0" multisrc"shell/{completion,key-bindings}.zsh"\
    id-as"junegunn/fzf_completions" pick"/dev/null"
FZF_DEFAULT_OPTS="--multi --height=60% --select-1 --exit-0 --reverse"
FZF_DEFAULT_OPTS+=" --bind ctrl-j:preview-down,ctrl-k:preview-up,ctrl-d:preview-page-down,ctrl-u:preview-page-up"
export FZF_DEFAULT_OPTS
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
nosearch=('\$RECYCLE.BIN')
nosearch+=('.git')
nosearch+=('RECYCLER')
nosearch+=('.metadata')
nosearch+=('node_modules')
find_dir="find ./ -type d \("
for d in $nosearch; do
    find_dir="$find_dir -name '$d' -o"
done
find_dir=${find_dir:0:-3}
find_file="$find_dir \) -prune -o -type f -print"
find_dir="$find_dir \) -prune -o -type d -print"
export FZF_ALT_C_COMMAND="$find_dir"
export FZF_ALT_C_OPTS="--preview 'tree -al {} | head -n 100'"
export FZF_CTRL_T_COMMAND="$find_file"
preview='[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file ||'
if type bat > /dev/null; then
    preview+='bat --color=always --style=header,grid --line-range :100 {}'
else
    preview+='head -n 100 {}'
fi
export FZF_CTRL_T_OPTS="--preview \"$preview\""
export FZF_COMPLETION_OPTS="--preview \"$preview\""
export FZF_COMPLETION_TRIGGER='**'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
