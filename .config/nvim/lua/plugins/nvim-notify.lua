---@module "lazy"
---@type LazyPluginSpec
return {
  "rcarriga/nvim-notify",
  event = { "VeryLazy" },
  init = function()
    require("notify").setup({
      merge_duplicates = true,
      render = "wrapped-compact",
      stages = "static",
      top_down = false,
    })
    vim.notify = require("notify")
  end,
  keys = {
    {
      "<Space>nd",
      function()
        require("notify").dismiss()
      end,
      { desc = "notify dismiss" },
    },
  },
}
