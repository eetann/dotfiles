---@module "lazy"
---@type LazyPluginSpec
return {
  "monaqa/dial.nvim",
  keys = {
    {
      "<C-a>",
      function()
        require("dial.map").manipulate("increment", "normal")
      end,
      mode = "n",
    },
    {
      "<C-x>",
      function()
        require("dial.map").manipulate("decrement", "normal")
      end,
      mode = "n",
    },
    -- normalのg<C-a>では、ドットリピートでの操作時のみインクリメント
    {
      "g<C-a>",
      function()
        require("dial.map").manipulate("increment", "gnormal")
      end,
      mode = "n",
    },
    {
      "g<C-x>",
      function()
        require("dial.map").manipulate("decrement", "gnormal")
      end,
      mode = "n",
    },
    {
      "<C-a>",
      function()
        require("dial.map").manipulate("increment", "visual")
      end,
      mode = "v",
    },
    {
      "<C-x>",
      function()
        require("dial.map").manipulate("decrement", "visual")
      end,
      mode = "v",
    },
    {
      "g<C-a>",
      function()
        require("dial.map").manipulate("increment", "gvisual")
      end,
      mode = "v",
    },
    {
      "g<C-x>",
      function()
        require("dial.map").manipulate("decrement", "gvisual")
      end,
      mode = "v",
    },
    {
      "<C-q>",
      function()
        require("dial.map").manipulate("increment", "normal", "checkbox")
      end,
      mode = { "n", "i" },
      ft = { "markdown", "mdx" },
      desc = "チェックボックスのトグル",
    },
    {
      "<C-q>",
      function()
        require("dial.map").manipulate("increment", "visual", "checkbox")
      end,
      mode = "v",
      ft = { "markdown", "mdx" },
      desc = "チェックボックスのトグル",
    },
  },
  config = function()
    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
      -- default augends used when no group name is specified
      default = {
        augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
        augend.constant.alias.bool,
        augend.constant.alias.ja_weekday,
        augend.date.alias["%Y/%m/%d"],
        augend.date.alias["%Y-%m-%d"],
        augend.date.alias["%Y年%-m月%-d日"],
        augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
        augend.constant.new({
          elements = { "xs", "sm", "md", "lg", "xl", "2xl", "3xl" },
          word = false,
          cyclic = false,
        }),
      },
      checkbox = {
        -- チェックボックスのトグル（なし→[ ]→[x]→なし）
        augend.user.new({
          ---@type fun(line: string, cursor?: integer): textrange?
          find = function(line)
            -- リストアイテムの行を検索
            local list_pattern = "^%s*[-+*] "
            local list_start, list_end = line:find(list_pattern)

            -- リストアイテムの場合
            if list_start ~= nil and list_end ~= nil then
              -- チェックボックスがある場合
              local checkbox_start = line:find("%[[%sx-]", list_end)
              if checkbox_start and checkbox_start == list_end + 1 then
                local checkbox_end = checkbox_start + 2 -- `[` + ((`x`or` `) + `]`)
                -- 範囲はチェックボックスの後のスペースの更に後ろ
                --   `- [x] foo` -> `foo`
                return { from = checkbox_start, to = checkbox_end + 1 } --[[@as textrange]]
              end
              -- チェックボックスがない場合
              -- リストアイテムの後ろから行末までを返す（`- foo` -> `foo`）
              return { from = list_end + 1, to = #line } --[[@as textrange]]
            end

            -- リストアイテムじゃない場合
            local first_non_space = line:match("^%s*()")
            if first_non_space then
              -- 範囲は行頭スペースを除いたもの
              --   `    foo bar`->`foo bar`
              return { from = first_non_space, to = #line } --[[@as textrange]]
            end
            -- 範囲は行全体 `foo bar`
            return { from = 1, to = #line } --[[@as textrange]]
          end,
          ---@type fun(self: Augend, text: string, addend: integer, cursor?: integer): addresult
          add = function(text, addend, cursor)
            -- カーソル位置の行全体を取得するためのハック
            -- （textは選択範囲の文字列だけなので、行全体の情報が必要）
            local line = vim.api.nvim_get_current_line()
            local list_pattern = "^%s*[-+*] "
            local is_list = line:find(list_pattern) ~= nil

            if is_list then
              -- リストアイテムの場合
              if text == "[ ]" or text == "[ ] " then
                -- [ ] → [x]
                return { text = "[x] " } --[[@as addresult]]
              elseif
                text == "[x]"
                or text == "[x] "
                or text == "[-]"
                or text == "[-] "
              then
                -- [x] → チェックボックスなし（削除）
                return { text = "", cursor = 0 } --[[@as addresult]]
              else
                -- チェックボックスなし（通常のテキスト） → [ ]
                return { text = "[ ] " .. text, cursor = 4 + #text } --[[@as addresult]]
              end
            else
              -- リストアイテムじゃない場合
              -- textは選択範囲の文字列がそのまま入ってる
              -- チェックボックス付きリストに変換
              return { text = "- [ ] " .. text, cursor = 6 + #text } --[[@as addresult]]
            end
          end,
        }),
      },
    })
  end,
}
