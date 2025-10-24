---@type overseer.TemplateDefinition
return {
  name = "atcoder test",
  builder = function()
    ---@type overseer.TaskDefinition
    return {
      cmd = "oj",
      args = { "test", "-d", "tests", "-c", "./main.out" },
      components = {
        { "on_exit_set_status", success_codes = { 0 } },
        {
          "open_output",
          direction = "vertical",
          on_complete = "failure",
          on_start = "never",
          focus = true,
        },
      },
    }
  end,
  condition = {
    dir = "~/ghq/github.com/eetann/myatcoder",
  },
}
