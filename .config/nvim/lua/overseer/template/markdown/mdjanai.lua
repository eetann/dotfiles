---@type overseer.TemplateDefinition
return {
  name = "mdjanai",
  builder = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local content = vim.fn.shellescape(table.concat(lines, "\n"))
    return {
      cmd = { "node" },
      args = {
        vim.fn.expand("~/ghq/github.com/eetann/mdjanai/dist/index.js"),
        "--",
        content,
      },
    }
  end,
  priority = 1,
  filetype = "markdown",
  condition = {
    callback = function()
      if vim.fn.expand("%:p"):match("cyber%-blog") then
        return false
      else
        return true
      end
    end,
  },
}
