local picker = require("snacks.picker")

local M = {}

local function insert_file_with_at_mark()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local bufnr = vim.api.nvim_get_current_buf()

  local picker_opts = {
    untracked = true,
    cwd = vim.uv.cwd(),
    confirm = function(the_picker)
      the_picker:close()
      local files = {}
      for _, item in ipairs(the_picker:selected({ fallback = true })) do
        if item.file then
          local relative_path = vim.fn.fnamemodify(item.file, ":~:.")
          table.insert(files, "@" .. relative_path)
        end
      end

      if #files > 0 then
        local text = table.concat(files, " ") .. " "
        vim.api.nvim_buf_set_text(bufnr, row - 1, col, row - 1, col, { text })
        vim.api.nvim_win_set_cursor(0, { row, col + #text })
      end
    end,
  }

  picker.git_files(picker_opts)
end

M.insert_files = insert_file_with_at_mark

return M
