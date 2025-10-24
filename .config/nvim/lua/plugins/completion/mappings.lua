---@module "blink.cmp"
---@type blink.cmp.KeymapConfig
return {
  preset = "super-tab",
  ["<C-u>"] = { "scroll_documentation_up", "fallback" },
  ["<C-d>"] = { "scroll_documentation_down", "fallback" },
  ["<C-b>"] = {},
  ["<C-f>"] = {},
  -- 補完候補を無視して、もっとも優先度の高いスニペットを展開する
  ["<C-y>"] = {
    function(cmp)
      if require("luasnip").expandable() then
        cmp.hide()
        vim.schedule(function()
          require("luasnip").expand()
        end)
        return true
      end
      return false
    end,
    "fallback",
  },
  -- 先頭の大文字小文字を切り替えて補完
  ["<C-v>"] = {
    function(cmp)
      cmp.accept({
        callback = function()
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<Esc>mzBvg~`za", true, false, true),
            "in",
            false
          )
        end,
      })
    end,
  },
  -- 直前に入れた空白を削除する
  -- `get Foo` -> `getFoo`
  -- getFoo, default_foo のようなprefixがあるときに使う
  ["<C-g>"] = {
    function()
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(
          '<Esc>mzF<Space>"_x`za',
          true,
          false,
          true
        ),
        "in",
        false
      )
    end,
  },
  -- ["<C-q>"] = require("minuet").make_blink_map(),
}
