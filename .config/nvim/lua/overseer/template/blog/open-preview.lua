---@type overseer.TemplateDefinition
return {
  name = "open blog preview",
  builder = function()
    local basename = vim.fn.expand("%:t:r")
    vim.ui.open("http://localhost:4321/blog/" .. basename)
    return {
      cmd = { "echo" },
      args = { basename },
    }
  end,
  priority = 1,
  condition = {
    dir = "~/ghq/github.com/eetann/cyber-blog",
  },
}
