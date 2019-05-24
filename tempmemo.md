# lspと補完について  
前提→neosnippetを使う  
|--------|---------|-----|----------|-----|  
| lsp    | vim-lsp | LCN | coc.nvim | ale |  
| format |         |     |          |     |  
| linter |         |     |          |     |  
| 補完   |         |     |          |     |  
|  


au User lsp_setup call lsp#register_server({  
        \ 'name': 'pyls',  
        \ 'cmd': {server_info->['/Users/hornm/.vim/run_pyls_with_venv.sh']},  
        \ 'whitelist': ['python'],  
        \ 'workspace_config': {  
        \   'pyls': {  
        \      'plugins': {  
        \         'pyflakes': {'enabled': v:true},  
        \         'pydocstyle': {'enabled': v:true},  
        \         'pylint': {'enabled': v:true}  
        \      }  
        \   }  
        \ }  
        \ })  
