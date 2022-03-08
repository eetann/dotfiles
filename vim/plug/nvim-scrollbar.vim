UsePlugin 'nvim-scrollbar'

lua << EOF
require('scrollbar.handlers.search').setup()
EOF
