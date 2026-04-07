---@module "lazy"
---@type LazyPluginSpec
return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cond = not vim.g.vscode,
  event = { "VeryLazy" },
  keys = {
    {
      "<Space>go",
      function()
        require("oil").open()
      end,
      desc = "Oil current buffer's directory",
    },
    {
      "<Space>gO",
      function()
        require("oil").open(".")
      end,
      desc = "Oil .",
    },
  },
  opts = {
    view_options = {
      show_hidden = true,
    },
    delete_to_trash = true,
    trash_command = "gomi",
    keymaps = {
      ["q"] = { "actions.close", mode = "n" },
    },
  },
}
