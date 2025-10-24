---@module "lazy"
---@type LazyPluginSpec
return {
  "rachartier/tiny-code-action.nvim",
  cond = not vim.g.vscode,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "folke/snacks.nvim" },
  },
  keys = {
    {
      "gra",
      function()
        require("tiny-code-action").code_action({})
      end,
      mode = { "n", "v" },
      desc = "Code Actions",
    },
  },
  opts = {
    picker = {
      "snacks",
      opts = {},
    },
  },
}
