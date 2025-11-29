---@module "lazy"
---@type LazyPluginSpec
return {
  dir = "~/ghq/github.com/eetann/idyank.nvim",
  keys = {
    { "<Space>y", "<Cmd>Idyank yank<CR>" },
  },
  cmd = "Idyank",
  opts = {},
}
