---@module "lazy"
---@type LazyPluginSpec
return {
  dir = "~/ghq/github.com/eetann/idyank.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-context",
  },
  keys = {
    { "<Space>y", "<Cmd>Idyank yank_with_filename<CR>" },
  },
  cmd = "Idyank",
  opts = {},
}
