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
vim.keymap.set("n", "<Space>X", function()
  vim.cmd("update")

  -- editpromptコマンドを実行
  vim.system({
    "node",
    vim.fn.expand("~/ghq/github.com/eetann/editprompt/dist/index.js"),
    "--capture",
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
