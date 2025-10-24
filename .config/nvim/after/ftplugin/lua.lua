if vim.b.my_plugin_lua ~= nil then
  return
end
vim.b.my_plugin_lua = true

local function format_line()
  local line = vim.fn.getline(".")
  local start = line:match("^--- ")
  local tag_start, tag_end = line:find("%*.*%*")
  if start and tag_start then
    local content = line:sub(5)
    local target_length = 78
    local current_length = #content
    if current_length < target_length then
      local spaces_needed = target_length - current_length
      local formatted_line = start
        .. line:sub(5, tag_start - 1)
        .. string.rep(" ", spaces_needed)
        .. line:sub(tag_start, tag_end)
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.fn.setline(".", formatted_line)
    end
  end
end

vim.keymap.set(
  { "n", "x" },
  "gq",
  format_line,
  { buffer = true, desc = "lua内でヘルプを書く時用" }
)
