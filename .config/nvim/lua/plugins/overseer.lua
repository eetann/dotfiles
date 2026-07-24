---@module "lazy"
---@type LazyPluginSpec
return {
  "stevearc/overseer.nvim",
  version = "^2",
  keys = {
    { "<space>r", "<CMD>OverseerRun<CR>" },
    { "<space>R", "<CMD>OverseerToggle<CR>" },
  },
  opts = {},
}
