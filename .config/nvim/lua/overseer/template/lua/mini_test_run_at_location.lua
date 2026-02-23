---@type overseer.TemplateProvider
return {
  condition = { filetype = "lua" },
  generator = function(opts)
    if not vim.fn.expand("%"):match("test.*.lua") then
      return "ファイル名がtest*.luaパターンに一致しない"
    end
    return {
      {
        name = "MiniTest run at location",
        builder = function()
          local file = vim.fn.expand("%")
          local line = vim.fn.line(".")
          ---@type overseer.TaskDefinition
          return {
            cmd = [[nvim --headless --noplugin -u ./scripts/test/minimal_init.lua -c "lua MiniTest.run_at_location]]
              .. [[({file = ']]
              .. file
              .. "',line="
              .. line
              .. [[})"]],
            cwd = vim.fn.getcwd(),
            components = {
              "open_output",
              { "on_complete_notify", statuses = {} },
              "restart_on_save",
              "default",
            },
          }
        end,
      },
    }
  end,
}
