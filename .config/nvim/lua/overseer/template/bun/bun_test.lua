---@type overseer.TemplateDefinition
return {
  name = "bun test this file",
  builder = function()
    local file = vim.fn.expand("%:p")
    ---@type overseer.TaskDefinition
    return {
      cmd = { "bun" },
      args = { "test", file },
      cwd = vim.fn.getcwd(),
      components = {
        "open_output",
        "default",
      },
    }
  end,
  condition = {
    callback = function()
      if
        vim.fn.filereadable("bun.lock") == 1
        and vim.bo.filetype == "typescript"
      then
        return true
      end
      return false
    end,
  },
}
