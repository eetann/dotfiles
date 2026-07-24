---@type overseer.TemplateProvider
return {
  condition = { filetype = "markdown" },
  generator = function(opts)
    local file = vim.fn.expand("%:p")
    if file:match(".*local/share/nvim/scratch/.*markdown") then
      return "使用不可"
    end
    return {
      {
        name = "markdown preview",
        tags = { require("overseer").TAG.RUN },
        builder = function()
          vim.cmd("MarkdownPreview")
          return {
            cmd = { "echo" },
            args = { file },
          }
        end,
      },
    }
  end,
}
