return {
  "SirVer/ultisnips",
  dependencies = { "honza/vim-snippets" },
  event = { "VeryLazy" },
  init = function()
    vim.g.UltiSnipsSnippetDirectories = { "~/dotfiles/.config/nvim/snippet" }
    vim.g.UltiSnipsJumpForwardTrigger = "<Plug>(ultisnips_jump_forward)"
  end,
}
