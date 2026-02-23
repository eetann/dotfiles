---@type overseer.TemplateProvider
return {
  generator = function(opts)
    local denols = vim
      .iter(vim.lsp.get_clients({ bufnr = 0 }))
      :find(function(c)
        return c.name == "denols"
      end)
    if not denols then
      return "denols LSPが起動していない"
    end
    return {
      {
        name = "deno test this file",
        builder = function()
          local file = vim.fn.expand("%:p")
          ---@type overseer.TaskDefinition
          return {
            cmd = { "deno" },
            args = { "test", "-A", file },
            cwd = vim.fn.expand("%:p:h"),
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
