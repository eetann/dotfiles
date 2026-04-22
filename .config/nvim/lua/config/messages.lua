local messages = require("vim._core.ui2.messages")
local original_msg_show = messages.msg_show

-- マッチしたら通知しないパターン一覧
local skip_patterns = {
  "Index out of bounds",
  "failed to run generator.*is not executable",
  "no matching language servers",
  "is not supported by any of the servers registered for the current buffer",
  "query: invalid node type",
  "No code actions available",
  "DiagnosticChanged Autocommands for.*Invalid",
  "^wrap$",
  "^unwrap$",
}

messages.msg_show = function(
  kind,
  content,
  replace_last,
  history,
  append,
  id,
  trigger
)
  -- 特定のメッセージをフィルタリング
  if kind == "bufwrite" then
    return -- 'written'メッセージを非表示
  end

  -- contentを文字列に正規化してパターンマッチ
  local text = ""
  if type(content) == "table" then
    for _, chunk in ipairs(content) do
      text = text .. chunk[2]
    end
  else
    text = tostring(content)
  end

  for _, pattern in ipairs(skip_patterns) do
    if text:match(pattern) then
      return
    end
  end

  if kind == "echo" then
    -- echo メッセージを vim.notify に転送
    require("notify")(text, vim.log.levels.INFO)
    return
  end

  -- その他のメッセージは通常通り表示
  original_msg_show(kind, content, replace_last, history, append, id, trigger)
end

require("vim._core.ui2").enable({
  msg = {
    targets = {
      echo = "cmd",
    },
  },
})
