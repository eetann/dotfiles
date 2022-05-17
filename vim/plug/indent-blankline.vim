UsePlugin 'indent-blankline.nvim'

lua << EOF
vim.opt.list = true
vim.opt.listchars:append("eol:↲")
vim.opt.listchars:append("trail:-")
vim.opt.listchars:append("nbsp:%")
vim.opt.listchars:append("extends:»") -- wrapの末尾
vim.opt.listchars:append("precedes:«") -- wrapの先頭

require("indent_blankline").setup {
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
}
EOF
