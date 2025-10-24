return {
  "petertriho/nvim-scrollbar",
  cond = not vim.g.vscode,
  event = { "VeryLazy" },
  opts = {
    excluded_filetypes = {
      "prompt",
      "cmp_docs",
      "cmp_menu",
      "TelescopePrompt",
      "noice",
      "LspsagaHover",
    },
  },
}
