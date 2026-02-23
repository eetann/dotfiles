---@type overseer.TemplateProvider
return {
  condition = { filetype = "typescript" },
  generator = function(opts)
    if vim.fn.filereadable("bun.lock") ~= 1 then
      return "bun.lockが見つからない"
    end
    return {
      {
        name = "bun run this file",
        builder = function()
          local file = vim.fn.expand("%:p")
          ---@type overseer.TaskDefinition
          return {
            cmd = { "bun" },
            args = { "run", file },
            cwd = vim.fn.getcwd(),
            components = {
              "open_output",
              "default",
            },
          }
        end,
      },
    }
  end,
}
