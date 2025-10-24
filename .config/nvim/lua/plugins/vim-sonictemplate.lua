return {
  "mattn/vim-sonictemplate",
  cmd = { "Tem", "Template" },
  init = function()
    vim.g.sonictemplate_vim_template_dir =
      { "~/dotfiles/.config/nvim/template" }
  end,
}
