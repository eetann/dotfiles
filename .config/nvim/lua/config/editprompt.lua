if not vim.env.EDITPROMPT then
  return
end

vim.opt.wrap = true

vim.keymap.set("n", "<Space>x", function()
  vim.cmd("update")
  -- バッファの内容を取得
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, "\n")

  -- editpromptコマンドを実行
  vim.system(
    {
      "node",
      vim.fn.expand("~/ghq/github.com/eetann/editprompt/dist/index.js"),
      "input",
      "--always-copy",
      "--",
      content,
    },
    -- { "editprompt", "--", content },
    { text = true },
    function(obj)
      vim.schedule(function()
        if obj.code == 0 then
          -- 成功したらバッファを空にする
          vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
          vim.cmd("silent write")
        else
          -- 失敗したら通知
          vim.notify(
            "editprompt failed: " .. (obj.stderr or "unknown error"),
            vim.log.levels.ERROR
          )
        end
      end)
    end
  )
end, { silent = true, desc = "Send buffer content to editprompt" })

vim.keymap.set("n", "<Space>sx", function()
  vim.cmd("update")
  -- バッファの内容を取得
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, "\n")

  -- editpromptコマンドを実行
  vim.system(
    {
      "node",
      vim.fn.expand("~/ghq/github.com/eetann/editprompt/dist/index.js"),
      "input",
      "--auto-send",
      "--",
      content,
    },
    -- { "editprompt", "--", content },
    { text = true },
    function(obj)
      vim.schedule(function()
        if obj.code == 0 then
          -- 成功したらバッファを空にする
          vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
          vim.cmd("silent write")
          -- render-markdown.nvimの描画を空にする
          vim.api.nvim_buf_clear_namespace(
            0,
            require("render-markdown.core.ui").ns,
            0,
            -1
          )
        else
          -- 失敗したら通知
          vim.notify(
            "editprompt failed: " .. (obj.stderr or "unknown error"),
            vim.log.levels.ERROR
          )
        end
      end)
    end
  )
end, { silent = true, desc = "Send buffer content to editprompt" })

vim.keymap.set("n", "<Space>X", function()
  vim.cmd("update")

  -- editpromptコマンドを実行
  vim.system({
    "node",
    vim.fn.expand("~/ghq/github.com/eetann/editprompt/dist/index.js"),
    "dump",
  }, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code == 0 then
        vim.cmd("silent write")
        -- 標準出力を行に分割
        local output_lines = vim.split(obj.stdout, "\n")

        -- バッファが空かチェック
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local is_empty = #lines == 1 and lines[1] == ""

        if is_empty then
          -- 空なら最初から書き換え
          vim.api.nvim_buf_set_lines(0, 0, -1, false, output_lines)
          vim.cmd("normal 2j")
        else
          -- 空じゃなければ最後+1行目に追加
          table.insert(output_lines, 1, "")
          local line_count = vim.api.nvim_buf_line_count(0)
          vim.api.nvim_buf_set_lines(
            0,
            line_count,
            line_count,
            false,
            output_lines
          )
          vim.cmd("normal 4j")
        end

        vim.cmd("silent write")
      else
        -- 失敗したら通知
        vim.notify(
          "editprompt failed: " .. (obj.stderr or "unknown error"),
          vim.log.levels.ERROR
        )
      end
    end)
  end)
end, { silent = true, desc = "Capture from editprompt quote mode" })

-- ファイル選択して @ prefix で挿入
local function insert_files_with_fzf()
  -- インサートモードでなければ挿入モードに移行
  local mode = vim.api.nvim_get_mode().mode
  if mode ~= "i" then
    vim.cmd("normal! a")
  end

  -- カーソル位置を取得
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  local col = cursor[2]

  -- まず FZF_CTRL_T_COMMAND でファイルリストを取得
  local fzf_ctrl_t_cmd = vim.env.FZF_CTRL_T_COMMAND or "fd --type f"
  local file_list_result = vim
    .system({ "sh", "-c", fzf_ctrl_t_cmd }, { text = true })
    :wait()

  if
    file_list_result.code ~= 0
    or not file_list_result.stdout
    or file_list_result.stdout == ""
  then
    return
  end

  -- heredoc でファイルリストを fzf-tmux に渡す
  local shell_cmd = string.format(
    [[fzf-tmux -p 80%% --multi --preview 'bat --color=always --theme=gruvbox-dark --style=plain --line-range :200 {} 2>/dev/null || cat {} 2>/dev/null | head -200' --preview-window 'down,60%%,wrap' << 'FZF_EOF'
%s
FZF_EOF]],
    file_list_result.stdout
  )

  -- fzf-tmux を同期実行して結果を待つ
  local result = vim.system({ "sh", "-c", shell_cmd }, { text = true }):wait()

  -- 終了コード確認（130はユーザーキャンセル）
  if result.code ~= 0 and result.code ~= 130 then
    return
  end

  -- stdoutから結果を取得
  if not result.stdout or result.stdout == "" then
    return
  end

  -- 結果を行に分割
  local selected = vim.split(vim.trim(result.stdout), "\n")

  if #selected == 0 then
    return
  end

  -- 相対パスに変換
  local relative_files = {}
  for _, file in ipairs(selected) do
    local relative_path = vim.fn.fnamemodify(file, ":~:.")
    table.insert(relative_files, relative_path)
  end

  -- 複数ファイルの場合
  if #relative_files > 1 then
    -- カーソル行の内容をチェック
    local current_line = vim.api.nvim_get_current_line()
    local is_empty_line = current_line:match("^%s*$") ~= nil

    -- Markdownリスト形式に変換
    local list_lines = {}
    for _, path in ipairs(relative_files) do
      table.insert(list_lines, "- @" .. path)
    end

    if is_empty_line then
      -- 空白行ならカーソル行に挿入
      vim.api.nvim_buf_set_lines(0, row - 1, row, false, list_lines)
    else
      -- 文字列があるなら次の行に挿入
      vim.api.nvim_buf_set_lines(0, row, row, false, list_lines)
    end
  else
    -- 単一ファイルの場合
    local char_before_cursor = ""
    if col > 0 then
      local line = vim.api.nvim_get_current_line()
      char_before_cursor = line:sub(col, col)
    end

    -- 空白チェック
    local prefix = ""
    if char_before_cursor ~= "" and not char_before_cursor:match("%s") then
      prefix = " "
    end

    local insert_text = prefix .. "@" .. relative_files[1] .. " "
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { insert_text })

    -- カーソルを挿入テキストの末尾に移動
    vim.api.nvim_win_set_cursor(0, { row, col + #insert_text })
  end
end

vim.keymap.set({ "n", "i" }, "<C-g>@", function()
  insert_files_with_fzf()
end, { silent = true, desc = "Insert files with @ prefix" })
