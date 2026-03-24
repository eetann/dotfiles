return {
  "akinsho/bufferline.nvim",
  cond = not vim.g.vscode and not vim.env.EDITPROMPT,
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  keys = {
    { "[b", "<cmd>BufferLineCyclePrev<CR>", desc = "Move to previous buffer" },
    { "]b", "<cmd>BufferLineCycleNext<CR>", desc = "Move to next buffer" },
    { "[B", "<cmd>BufferLineMovePrev<CR>", desc = "Re-order to previous" },
    { "]B", "<cmd>BufferLineMoveNext<CR>", desc = "Re-order to next" },
    {
      "sq",
      function()
        local now_bufnr = vim.fn.bufnr()
        vim.cmd([[BufferLineCycleNext]])
        vim.cmd(("bdelete %d"):format(now_bufnr))
      end,
      desc = "Close current buffer without closing the current window",
    },
    {
      "sQ",
      function()
        local now_bufnr = vim.fn.bufnr()
        vim.cmd([[BufferLineCycleNext]])
        vim.cmd(("bdelete! %d"):format(now_bufnr))
      end,
      desc = "Close! current buffer without closing the current window",
    },
    { ";", "<cmd>BufferLinePick<CR>", desc = "Pick buffer" },
  },
  opts = function()
    local bufferline = require("bufferline")
    return {
      options = {
        style_preset = bufferline.style_preset.no_italic,
        close_command = "bdelete %d",
        right_mouse_command = nil,
        max_name_length = 40,
        buffer_close_icon = "",
        name_formatter = function(buf)
          if buf.path:match("%.nb/home/.*.md") then
            local file = io.open(buf.path, "r")

            if not file then
              return
            end
            local first_line = file:read("*l")
            file:close()
            -- Markdownの見出し（# 見出し）のパターンにマッチするかチェック
            local heading = first_line:match("^#%s+(.+)")

            if heading then
              return heading
            end
          end
        end,
      },
    }
  end,
}
