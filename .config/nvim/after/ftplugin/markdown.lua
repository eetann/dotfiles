if vim.b.my_plugin_markdown ~= nil then
  return
end
vim.b.my_plugin_markdown = true

vim.opt_local.wrap = true

local function is_in_num_list()
  local current_line = vim.api.nvim_get_current_line()
  return current_line:match("^%s*%d+%.%s") ~= nil
end
vim.keymap.set("i", "<CR>", function()
  if is_in_num_list() then
    local line = vim.api.nvim_get_current_line()
    local modified_line = line:gsub("^%s*(%d+)%.%s.*$", function(numb)
      numb = tonumber(numb) + 1
      return tostring(numb)
    end)
    return "<CR>" .. modified_line .. ". "
  else
    return "<CR>"
  end
end, {
  desc = "Markdownの時は番号リストのインクリメントを追加",
  buffer = true,
  expr = true,
  silent = true,
})

-- ref: https://vi.stackexchange.com/questions/9344/open-markdown-filename-under-cursor-like-gf-and-jump-to-the-section
vim.keymap.set("n", "gf", function()
  local cfile = vim.fn.expand("<cfile>")
  -- ([^#]*) -> ファイル名 -> %1
  -- (#+) -> 見出しのシャープ -> %2
  -- ([^#]*) -> 見出しテキスト -> %3
  local arg = cfile:gsub(
    "([^#]*)(#+)([^#]*)",
    function(filename, hashes, heading)
      -- 見出しテキストの`-`をエスケープ
      local escaped_heading = heading:gsub("-", ".")
      return "+/" .. hashes .. "\\ " .. escaped_heading .. " " .. filename
    end
  )
  vim.cmd("edit " .. arg)
end, { desc = "gfを拡張: 見出しリンクも辿れる", buffer = true })

-- 現在の箇所をwikilink化
vim.keymap.set("n", "<space>mw", function()
  -- 現在の位置をmで記録
  vim.cmd("mark z")

  -- 現在のテキストの見出しに移動
  vim.fn.search("^#", "b")

  -- 見出しテキストを取得してエスケープする
  local heading_link = ""
  if vim.fn.line(".") ~= 1 then
    local line = vim.api.nvim_get_current_line()
    heading_link = line:gsub("(#+)%s+([^#]*)", function(hashes, heading)
      -- 見出しテキストをエスケープ
      local escaped_heading = heading:gsub("[][%s^$*(){}|]", "-")
      return hashes .. escaped_heading
    end)
    -- 1行目に移動
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
  end

  -- タイトルの取得
  local line = vim.api.nvim_get_current_line()
  local title = line:match("#%s+([^#]*)")

  -- リンクの取得
  local current_file = vim.fn.expand("%")
  local link = "[[" .. current_file .. heading_link .. "|" .. title .. "]]"
  vim.fn.setreg("+", link)
  vim.print("yank '" .. link .. "'")

  -- 元の位置に戻る
  vim.cmd("normal `z")
end, { desc = "現在行のwikilinkを取得", buffer = true })

-- チェックボックスのトグル
local function toggle_checkbox_line(line)
  local indent = vim.fn.matchstr(line, [[^\s*]])
  local content_start = #indent + 1

  local new_line
  local col_offset = 0
  local checkbox_end_pos = 0 -- チェックボックスの終了位置

  if vim.fn.match(line, [=[\v^\s*[-+*]\s+\[ \]\s+]=]) >= 0 then
    -- [ ] → [x]
    new_line =
      vim.fn.substitute(line, [=[\v^(\s*[-+*]\s+)\[ \]]=], [=[\1[x]]=], "")
    col_offset = 0
    checkbox_end_pos = #indent + 2 + 4 -- インデント + "- " + "[ ] "
  elseif vim.fn.match(line, [=[\v^\s*[-+*]\s+\[x\]\s+]=]) >= 0 then
    -- [x] → 箇条書き
    new_line =
      vim.fn.substitute(line, [=[\v^(\s*[-+*]\s+)\[x\]\s+]=], [[\1]], "")
    col_offset = -4 -- "[x] "の分
    checkbox_end_pos = #indent + 2 + 4
  elseif vim.fn.match(line, [[\v^\s*[-+*]\s+\[-\]\s+]]) >= 0 then
    -- [-] → 箇条書き
    new_line =
      vim.fn.substitute(line, [=[\v^(\s*[-+*]\s+)\[-\]\s+]=], [[\1]], "")
    col_offset = -4 -- "[-] "の分
    checkbox_end_pos = #indent + 2 + 4
  elseif vim.fn.match(line, [=[\v^\s*[-+*]\s+]=]) >= 0 then
    -- 箇条書き → [ ]
    new_line = vim.fn.substitute(line, [=[\v^(\s*[-+*]\s+)]=], [[\1[ ] ]], "")
    col_offset = 4
    checkbox_end_pos = #indent + 2
  else
    -- 普通のテキスト → リスト
    new_line = indent .. "- [ ] " .. line:sub(content_start)
    col_offset = 6
    checkbox_end_pos = 0
  end

  return new_line, col_offset, checkbox_end_pos
end

local function toggle_checkbox()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local col = cursor_pos[2]

  local new_line, col_offset, checkbox_end_pos = toggle_checkbox_line(line)

  -- カーソルがチェックボックスより右にある場合のみオフセットを適用
  local new_col = col
  if col >= checkbox_end_pos then
    new_col = math.max(0, col + col_offset)
  end

  vim.api.nvim_set_current_line(new_line)
  vim.api.nvim_win_set_cursor(0, { cursor_pos[1], new_col })
end

local function toggle_checkbox_visual()
  -- ビジュアルモードの選択範囲を取得
  local start_pos = vim.fn.getpos("v") -- Visualモード開始位置
  local end_pos = vim.fn.getpos(".") -- 現在カーソル位置
  local start_line = start_pos[2]
  local end_line = end_pos[2]

  -- 小さい方を先にする
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  for line_num = start_line, end_line do
    local line = vim.fn.getline(line_num)
    local new_line, _, _ = toggle_checkbox_line(line)
    vim.fn.setline(line_num, new_line)
  end
end

vim.keymap.set({ "n", "i" }, "<C-q>", toggle_checkbox, {
  desc = "チェックボックスのトグル",
  buffer = true,
})

vim.keymap.set("x", "<C-q>", toggle_checkbox_visual, {
  desc = "チェックボックスのトグル",
  buffer = true,
})
