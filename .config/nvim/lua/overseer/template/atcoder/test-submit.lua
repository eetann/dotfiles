---@type overseer.TemplateDefinition
return {
  name = "atcoder test and submit",
  builder = function()
    ---@type overseer.TaskDefinition
    return {
      cmd = "",
      components = {
        {
          "dependencies",
          task_names = { "g++ build only", "atcoder test", "atcoder submit" },
          sequential = true,
        },
        "default",
      },
    }
  end,
  priority = 20,
  condition = {
    dir = "~/ghq/github.com/eetann/myatcoder",
  },
}
