---@type overseer.TemplateDefinition
return {
  name = "markdown preview",
  condition = { filetype = "markdown" },
  builder = function()
    local file = vim.fn.expand("%:p")
    vim.cmd("MarkdownPreview")
    return {
      cmd = { "echo" },
      args = { file },
    }
  end,
  tags = { require("overseer").TAG.RUN },
}
