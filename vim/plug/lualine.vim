UsePlugin 'lualine.nvim'

set laststatus=3 " ステータスラインを常に表示
set noshowmode   " 現在のモードを日本語表示しない
set showcmd      " 打ったコマンドをステータスラインの下に表示
set ruler        " ステータスラインの右側にカーソルの現在位置を表示する

lua << EOF
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'powerline',
    component_separators = { left = ' ', right = ' '},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {
      {
        'filename',
        file_status = true, -- readonly, modified
        path = 1, -- Relative path
        shorting_target = 40,
        symbols = {
          modified = ' ●',
          readonly = ' ',
          unnamed = '[No Name]',
          }
      }
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {
      {
        'diagnostics',
        source = {'nvim-lsp'},
      },
    },
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
EOF
