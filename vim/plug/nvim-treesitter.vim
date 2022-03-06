UsePlugin 'nvim-treesitter'
" treesitter

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  }
}
EOF
