---@module "lazy"
---@type LazyPluginSpec
return {
  "zbirenbaum/copilot.lua",
  lazy = true,
  opts = {
    suggestion = {
      enabled = true,
      keymap = {
        accept = "<C-g>a",
        accept_word = false,
        accept_line = "<C-g>l",
        prev = "<C-g>[",
        next = "<C-g>]",
        dismiss = "<C-g>e",
      },
    },
    panel = { enabled = false },
  },
}
