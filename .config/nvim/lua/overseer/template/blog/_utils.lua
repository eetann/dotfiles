M = {}

function M.get_slug()
  local filename = vim.fn.expand("%:t")
  return vim.fn.fnamemodify(filename, ":t:r")
end

function M.get_file_list()
  local content =
    vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)

  -- 画像と動画のファイル名リストを作成
  local file_list = {}
  for _, line in ipairs(content) do
    local media_filename = line:match("src=[\"']@:([%w-_%.]+)")
    if media_filename then
      table.insert(file_list, media_filename)
    end
  end

  return file_list
end

return M
