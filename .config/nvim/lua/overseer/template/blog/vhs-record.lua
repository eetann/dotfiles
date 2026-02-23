---@type overseer.TemplateDefinition
return {
  name = "vhs record",
  builder = function()
    local filename = vim.fn.expand("%:~:.")
    return {
      cmd = { "vhs" },
      args = { filename },
    }
  end,
  tags = { require("overseer").TAG.RUN },
  condition = {
    filetype = "vhs",
  },
}
