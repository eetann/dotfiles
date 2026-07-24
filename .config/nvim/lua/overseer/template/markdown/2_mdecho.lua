---@type overseer.TemplateProvider
return {
  name = "mdecho",
  condition = { filetype = "markdown" },
  generator = function(opts)
    local file = vim.fn.expand("%:p")
    if file:match(".*local/share/nvim/scratch/.*markdown") then
      return "使用不可"
    end
    return {
      {
        name = "mdecho レンダリングと返信",
        tags = { require("overseer").TAG.RUN },
        builder = function()
          return {
            cmd = { "bun" },
            args = {
              "run",
              vim.fn.expand("~/ghq/github.com/eetann/mdecho/src/index.ts"),
              "--file",
              vim.fn.expand("%"),
            },
          }
        end,
      },
    }
  end,
}
