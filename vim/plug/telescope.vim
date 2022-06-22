UsePlugin "telescope.nvim"
" Fuzzy finder

nmap <Leader>f [fzf-p]
xmap <Leader>f [fzf-p]

" Find files using Telescope command-line sugar.
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
  local num_selections = #picker:get_multi_selection()
  if not num_selections or num_selections <= 1 then
    actions.add_selection(prompt_bufnr)
  end

  actions.close(prompt_bufnr)
  if open_cmd ~= 'edit' then
    vim.api.nvim_command(open_cmd)
  end
  local cwd = picker.cwd
  if cwd == vim.fn.getcwd() then
    cwd = ''
  elseif cwd == nil then
    cwd = ''
  else
    cwd = cwd .. '/'
  end
  for _, selection in ipairs(picker:get_multi_selection()) do
    local file_name = selection.value
    vim.api.nvim_command('edit' .. ' ' .. cwd .. file_name)
  end

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


local telescope = require('telescope')
telescope.setup{
  defaults = {
    sorting_strategy = "ascending",
    layout_strategy = 'horizontal',
    layout_config = {
      prompt_position = 'top',
      preview_width = 0.5
    }
  },
  pickers = {
    find_files = {
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<CR>"] = telescope_custom_actions.multi_selection_open,
          ["<C-v>"] = telescope_custom_actions.multi_selection_open_vsplit,
          ["<C-x>"] = telescope_custom_actions.multi_selection_open_split,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        },
      },
    },
    git_files = {
      file_ignore_patterns = { "node_modules/", ".git/" },
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<CR>"] = telescope_custom_actions.multi_selection_open,
          ["<C-v>"] = telescope_custom_actions.multi_selection_open_vsplit,
          ["<C-x>"] = telescope_custom_actions.multi_selection_open_split,
        },
      },
    },
  },
}

telescope.custom = {
  project_files = function()
    local ok = pcall(require"telescope.builtin".git_files, {})
    if not ok then require"telescope.builtin".find_files({hidden=true}) end
  end
}

vim.api.nvim_set_keymap("n", "[fzf-p]f", "<CMD>lua require'telescope'.custom.project_files()<CR>", {noremap = true, silent = true})
EOF
