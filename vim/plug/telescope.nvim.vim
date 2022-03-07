UsePlugin "telescope.nvim"
" Fuzzy finder

nmap <Leader>f [fzf-p]
xmap <Leader>f [fzf-p]

" Find files using Telescope command-line sugar.
nnoremap [fzf-p]f <cmd>Telescope find_files hidden=true<cr>
nnoremap [fzf-p]g <cmd>Telescope live_grep<cr>
nnoremap [fzf-p]b <cmd>Telescope buffers<cr>
nnoremap [fzf-p]h <cmd>Telescope help_tags<cr>
nnoremap <F6> <cmd>Telescope git_files cwd=~/dotfiles<cr>

lua << EOF
local actions = require("telescope.actions")
require('telescope').setup{
  defaults = {
    borderchars = { ".", ":", ".", ":", ".", ".", ".", "." },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
    sorting_strategy = "ascending",
    layout_strategy = 'horizontal',
    layout_config = {
      prompt_position = 'top',
    }
  },
}
EOF
