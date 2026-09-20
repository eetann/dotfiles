# 30秒以上のコマンドは実行終了時にデスクトップ通知
# ref: https://github.com/marzocchi/zsh-notify/blob/9c1dac81a48ec85d742ebf236172b4d92aab2f3f/notify.plugin.zsh#L84

# 通知をスキップするコマンドのパターン（拡張正規表現）
# - 先頭の環境変数指定（FOO=bar cmd ...）は除去してからマッチするのでパターンに含めない
# - 末尾の `( |$)` はコマンド名の部分一致（git が gitlab-runner にマッチする等）を防ぐため
SKIP_NOTIFY_PATTERNS=(
  # 対話的に使うもの（エディタ・TUI・エージェント）
  '^(claude|codex|opencode|nvim|vim|idea|lazygit|lg|ml|nb|man|fg|ssh)( |$)'
  '^vagrant ssh( |$)'
  # 出力を眺めるだけのもの
  '^(bat|cat|git|difit)( |$)'
  # 常駐するもの（開発サーバー・ウォッチャー）
  '^(watch|mt)( |$)'
  '^(npm|pnpm|yarn|bun)( run)? (dev|preview|server|start|watch)( |$)'
  # 設定変更など、通知するまでもないもの
  '^tmux set-option( |$)'
)

function is_skip_command() {
  local cmd="$1"
  # 先頭の環境変数指定（FOO=bar cmd ...）を取り除く
  while [[ "$cmd" == [A-Za-z_][A-Za-z0-9_]*=*[[:space:]]* ]]; do
    cmd="${cmd#*[[:space:]]}"
  done

  local pattern
  for pattern in "${SKIP_NOTIFY_PATTERNS[@]}"; do
    if [[ "$cmd" =~ "$pattern" ]]; then
      return 0
    fi
  done
  return 1
}

function windows_notify() {
  # Powershellでの通知: https://qiita.com/relu/items/b7121487a1d5756dfcf9
  # WSL内での実行方法: https://zenn.dev/kaityo256/articles/make_shortcut_from_wls
  local temp_ps1
  temp_ps1=$(mktemp).ps1
  cat <<'EOD' > "$temp_ps1"
param (
    [string]$message = "Command completed!"
)

$xml = @"
<toast>

  <visual>
    <binding template="ToastGeneric">
      <text>$($message)</text>
      <text>Finish!</text>
    </binding>
  </visual>

  <audio src="ms-winsoundevent:Notification.Reminder"/>

</toast>
"@
$XmlDocument = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]::New()
$XmlDocument.loadXml($xml)
$AppId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]::CreateToastNotifier($AppId).Show($XmlDocument)
EOD

local ps1file
ps1file=$(wslpath -w "$temp_ps1")
/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -ExecutionPolicy Bypass "$ps1file" -message "$1"
rm -f "$temp_ps1"
}

# sleep 10;notify のように書くと、短いやつでも通知できる
# 普通にnotifyでも実行できる
function notify() {
  local message="${1:-Finish}"
  if [[ "$(uname -s)" == "Darwin" ]]; then
    terminal-notifier -message "$message" -sound default > /dev/null 2>&1
  elif [[ "$(uname -r)" == *microsoft* ]]; then
    windows_notify "$message"
  fi
}

function notify_before_command() {
  declare -g my_notify_last_command="$1"
  declare -g my_notify_start_time=$EPOCHSECONDS
}

function unset_my_notify() {
  unset my_notify_last_command my_notify_start_time
}

function notify_after_command() {
  local command_complete_timeout=30

  if [ -z $my_notify_start_time ]; then
    return
  fi
  if is_skip_command "$my_notify_last_command"; then
    unset_my_notify
    return
  fi

  local time_elapsed=$((EPOCHSECONDS - my_notify_start_time))
  if (( time_elapsed < command_complete_timeout )); then
    unset_my_notify
    return
  fi

  notify "$my_notify_last_command"
  unset_my_notify
}

zmodload zsh/datetime
autoload -U add-zsh-hook
add-zsh-hook preexec notify_before_command
add-zsh-hook precmd notify_after_command
