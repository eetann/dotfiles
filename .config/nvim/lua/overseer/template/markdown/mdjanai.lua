---@type overseer.TemplateProvider
return {
  condition = { filetype = "markdown" },
  generator = function(opts)
    if vim.fn.expand("%:p"):match("cyber%-blog") then
      return "cyber-blogディレクトリでは使用不可"
    end
    return {
      {
        name = "mdjanai",
        tags = { require("overseer").TAG.RUN },
        builder = function()
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          local content = table.concat(lines, "\n")
          return {
            cmd = { "node" },
            args = {
              vim.fn.expand("~/ghq/github.com/eetann/mdjanai/dist/index.js"),
              "--",
              content,
            },
          }
        end,
      },
    }
  end,
}
