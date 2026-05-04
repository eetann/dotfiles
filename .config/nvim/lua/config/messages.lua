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
  "Already at .* change",
  ".*change; after .*ago",
  ".*change; before .* ago",
  ".*less; before .* ago",
  "more lines?",
  "fewer lines?",
  "^wrap$",
  "^unwrap$",
}

-- mini表示するパターン一覧（render="minimal"で短く通知）
local mini_patterns = {
  "yanked",
  "change;%sbefore",
  "change;%safter",
  "line less",
  "lines indented",
  "No lines in buffer",
  "search hit .*, continuing at",
  "E486: Pattern not found",
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

  for _, pattern in ipairs(mini_patterns) do
    if text:match(pattern) then
      require("notify")(text, vim.log.levels.INFO, {
        render = "minimal",
        timeout = 1500,
      })
      return
    end
  end

  if kind == "echo" then
    require("notify")(text, vim.log.levels.INFO)
    return
  end

  if kind == "wmsg" then
    require("notify")(text, vim.log.levels.WARN)
    return
  end

  if kind == "emsg" then
    require("notify")(text, vim.log.levels.ERROR)
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
