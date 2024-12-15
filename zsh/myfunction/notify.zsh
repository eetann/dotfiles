# 30秒以上のコマンドは実行終了時にデスクトップ通知
# ref: https://github.com/marzocchi/zsh-notify/blob/9c1dac81a48ec85d742ebf236172b4d92aab2f3f/notify.plugin.zsh#L84

# TODO: 重複をまとめる

# スキップ対象のコマンドリスト
SKIP_NOTIFY_COMMANDS=(
  fg
  bat
  cat
  lazygit
  lg
  man
  nb
  nvim
  ssh
  vim
  watch
  idea
  "vagrant ssh"
  "mise run emulate"
  "npm run dev"
  "npm run preview"
  "npm run server"
  "npm run start"
  "pnpm run dev"
  "pnpm run preview"
  "pnpm run server"
  "pnpm run start"
  "yarn run dev"
  "yarn run preview"
  "yarn run server"
  "yarn run start"
)

# コマンドがスキップ対象かチェックする関数
function is_skip_command() {
  local cmd="$1"
  for skip_cmd in "${SKIP_NOTIFY_COMMANDS[@]}"; do
    if [[ "$cmd" == "$skip_cmd" || "$cmd" == "$skip_cmd"* ]]; then
      return 0
    fi
  done
  return 1
}

function windows-notify() {
# Powershellでの通知: https://qiita.com/relu/items/b7121487a1d5756dfcf9
# WSL内での実行方法: https://zenn.dev/kaityo256/articles/make_shortcut_from_wls
  temp_ps1=`mktemp`.ps1
  cat <<'EOD' > $temp_ps1
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

  ps1file=$(wslpath -w $temp_ps1)
  /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -ExecutionPolicy Bypass $ps1file -message "$1"
  rm -f $temp_ps1
}

function before-command() {
  declare -g my_notify_last_command="$1"
  declare -g my_notify_start_time=$EPOCHSECONDS
}

function after-command() {
  local command_complete_timeout=30

  local last_status=$?
  local time_elapsed=$((EPOCHSECONDS - my_notify_start_time))
  # echo "Command: $my_notify_last_command"
  # echo "Start Time: $my_notify_start_time"
  # echo "Time Elapsed: $time_elapsed"
  # echo "Last Status: $last_status"

  if [ -z $my_notify_start_time ]; then
    return
  fi
  if is_skip_command "$my_notify_last_command"; then
    unset my_notify_last_command my_notify_start_time
    return
  fi

  if (( time_elapsed < command_complete_timeout )); then
    unset my_notify_last_command my_notify_start_time
    return
  fi

  if [[ "$(uname -s)" == "Darwin" ]]; then
    terminal-notifier -title "$my_notify_last_command" -message "Finish" -sound default > /dev/null 2>&1
  elif [[ "$(uname -r)" == *microsoft* ]]; then
    windows-notify "$my_notify_last_command"
  fi
  unset my_notify_last_command my_notify_start_time
}

# sleep 10;notify のように書くと、短いやつでも通知できる
# 普通にnotifyでも実行できる
function notify() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    terminal-notifier -message "Finish" -sound default > /dev/null 2>&1
  elif [[ "$(uname -r)" == *microsoft* ]]; then
    windows-notify "Finish!!!!"
  fi
}

zmodload zsh/datetime
autoload -U add-zsh-hook
add-zsh-hook preexec before-command
add-zsh-hook precmd after-command
