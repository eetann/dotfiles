UsePlugin "telescope.nvim"
" Fuzzy finder

nmap <Leader>f [fzf-p]
xmap <Leader>f [fzf-p]

" Find files using Telescope command-line sugar.
nnoremap [fzf-p]f <cmd>Telescope git_files<cr>
nnoremap [fzf-p]F <cmd>Telescope find_files hidden=true<cr>
nnoremap [fzf-p]g <cmd>Telescope live_grep<cr>
nnoremap [fzf-p]b <cmd>Telescope buffers<cr>
nnoremap [fzf-p]h <cmd>Telescope help_tags<cr>
nnoremap <F6> <cmd>Telescope git_files cwd=~/dotfiles<cr>

lua << EOF
local actions = require("telescope.actions")
local action_state = require('telescope.actions.state')
local telescope_custom_actions = {}

function telescope_custom_actions._multiopen(prompt_bufnr, open_cmd)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local selected_entry = action_state.get_selected_entry()
    local num_selections = #picker:get_multi_selection()
    if not num_selections or num_selections <= 1 then
        actions.add_selection(prompt_bufnr)
    end
    actions.send_selected_to_qflist(prompt_bufnr)
    vim.cmd("cfdo " .. open_cmd)
end
function telescope_custom_actions.multi_selection_open_vsplit(prompt_bufnr)
    telescope_custom_actions._multiopen(prompt_bufnr, "vsplit")
end
function telescope_custom_actions.multi_selection_open_split(prompt_bufnr)
    telescope_custom_actions._multiopen(prompt_bufnr, "split")
end
function telescope_custom_actions.multi_selection_open(prompt_bufnr)
    telescope_custom_actions._multiopen(prompt_bufnr, "edit")
end

require('telescope').setup{
  defaults = {
    file_ignore_patterns = { "node_modules", ".git" },
    borderchars = { ".", ":", ".", ":", ".", ".", ".", "." },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<CR>"] = telescope_custom_actions.multi_selection_open,
        ["<C-v>"] = telescope_custom_actions.multi_selection_open_vsplit,
        ["<C-x>"] = telescope_custom_actions.multi_selection_open_split,
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
