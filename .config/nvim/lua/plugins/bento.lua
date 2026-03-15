return {
  "serhez/bento.nvim",
  cond = not vim.g.vscode and not vim.env.EDITPROMPT,
  event = "VeryLazy",
  opts = {},
}
