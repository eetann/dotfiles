UsePlugin 'nvim-treesitter'
" treesitter

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = 'all',
  ignore_install = {'phpdoc'},
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  }
}
EOF
