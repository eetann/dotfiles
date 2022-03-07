UsePlugin "telescope.nvim"
" Fuzzy finder

nmap <Leader>f [fzf-p]
xmap <Leader>f [fzf-p]

" Find files using Telescope command-line sugar.
nnoremap [fzf-p]ff <cmd>Telescope find_files hidden=true<cr>
nnoremap [fzf-p]fg <cmd>Telescope live_grep<cr>
nnoremap [fzf-p]fb <cmd>Telescope buffers<cr>
nnoremap [fzf-p]fh <cmd>Telescope help_tags<cr>
nnoremap <F6> <cmd>Telescope find_files no_ignore=true search_dirs={"~/dotfiles"}<cr>

lua << EOF
require('telescope').setup{
  defaults = {
    layout_strategy = 'horizontal',
    layout_config = {
      prompt_position = 'top'
    }
  },
}
EOF
