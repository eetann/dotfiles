UsePlugin 'bufferline.nvim'

" These commands will navigate through buffers in order regardless of which mode you are using
" e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
nnoremap <silent>[b :BufferLineCycleNext<CR>
nnoremap <silent>]b :BufferLineCyclePrev<CR>

" These commands will move the current buffer backwards or forwards in the bufferline
nnoremap <silent>[B :BufferLineMoveNext<CR>
nnoremap <silent>:B :BufferLineMovePrev<CR>
nnoremap <silent> <Space><Space> :BufferLinePick<CR>

" These commands will sort buffers by directory, language, or a custom criteria
nnoremap <silent>be :BufferLineSortByExtension<CR>
nnoremap <silent>bd :BufferLineSortByDirectory<CR>
nnoremap <silent><mymap> :lua require'bufferline'.sort_buffers_by(function (buf_a, buf_b) return buf_a.id < buf_b.id end)<CR>

lua << EOF
require('bufferline').setup {
  options = {
    numbers = 'none',

    close_command = 'bdelete! %d',
    right_mouse_command = 'bdelete! %d',
    left_mouse_command = 'buffer %d',
    middle_mouse_command = nil,

    indicator_icon = '@ ',
    buffer_close_icon = 'x',
    modified_icon = 'o',
    close_icon = 'x',
    left_trunc_marker = '<',
    right_trunc_marker = '>',

    max_name_length = 18,
    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    tab_size = 18,
    diagnostics = false,

    show_buffer_icons = false,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = false,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    -- can also be a table containing 2 custom separators
    -- [focused and unfocused]. eg: { '|', '|' }
    separator_style = {' ', ' '},
    enforce_regular_tabs = false,
    always_show_bufferline = true,
    sort_by = 'id',
  },
  highlights = {
    buffer_selected = {
      gui = '',
    },
    duplicate_selected = {
      gui = '',
    },
    duplicate_visible = {
      gui = '',
    },
    duplicate = {
      gui = '',
    },
    pick_selected = {
      gui = 'bold'
    },
    pick_visible = {
      gui = 'bold'
    },
    pick = {
      gui = 'bold'
    }
    }
  }
EOF
