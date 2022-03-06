UsePlugin 'coc.nvim'
" 補完とLSP

set updatetime=300
let g:coc_global_extensions = [
\ 'coc-json',
\ 'coc-highlight',
\ 'coc-word',
\ 'coc-snippets',
\ 'coc-neosnippet',
\ 'coc-pyright',
\ 'coc-fzf-preview',
\ ]
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
let g:coc_start_at_startup = 1
let g:coc_config_home = $HOME.'/dotfiles/vim'

command! -nargs=0 Format :call CocAction('format')
highlight link CocHighlightText GruvboxBlueSign
autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
nnoremap <F10> :<C-u>CocConfig<CR>
inoremap <C-g> <C-o>:call CocActionAsync('showSignatureHelp')<CR>
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <F2> <Plug>(coc-rename)
if has('patch8.1.1068')
    " Use `complete_info` if your (Neo)Vim version supports it.
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
    imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Remap <C-d> and <C-u> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
  nnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
  inoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
  vnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
endif

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction
omap iF <Plug>(coc-funcobj-i)
omap aF <Plug>(coc-funcobj-a)
vmap iF <Plug>(coc-funcobj-i)
vmap aF <Plug>(coc-funcobj-a)
imap <silent><expr> <C-k>
\ neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" :
\ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
\ pumvisible() ? coc#_select_confirm() :
\ coc#refresh()
smap <silent><expr> <C-k>
\ neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" :
\ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
\ pumvisible() ? coc#_select_confirm() :
\ coc#refresh()
xmap <C-k> <Plug>(neosnippet_expand_target)
let g:coc_snippet_next =  '<c-k>'
let g:coc_snippet_prev = '<s-tab>'
" for fzf-preview
nmap <Leader>f [fzf-p]
xmap <Leader>f [fzf-p]

" For not installed ripgrep
let g:fzf_preview_directory_files_command="rg --files --hidden --follow --no-messages --glob '!**/.git/*' --glob '!**/node_modules/*'"
let g:fzf_preview_filelist_command="rg --files --hidden --follow --no-messages --glob '!**/.git/*' --glob '!**/node_modules/*'"
" let g:fzf_preview_use_dev_icons=1
nnoremap <silent> [fzf-p]p  :<C-u>CocCommand fzf-preview.FromResources project git<CR>
nnoremap <silent> [fzf-p]P  :<C-u> CocCommand fzf-preview.DirectoryFiles<CR>
nnoremap <silent> [fzf-p]o  :<C-u>CocCommand fzf-preview.FromResources mru<CR>
nnoremap <silent> [fzf-p]b  :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap <silent> [fzf-p]B  :<C-u>CocCommand fzf-preview.AllBuffers<CR>
nnoremap <silent> [fzf-p]j  :<C-u>CocCommand fzf-preview.Jumps<CR>
nnoremap <silent> [fzf-p]/  :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap          [fzf-p]gr :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
xnoremap          [fzf-p]gr "sy:CocCommand   fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nnoremap <silent> [fzf-p]m  :<C-u>CocCommand fzf-preview.Marks<CR>
nnoremap <silent> [fzf-p]q  :<C-u>CocCommand fzf-preview.QuickFix<CR>
nnoremap <silent> [fzf-p]l  :<C-u>CocCommand fzf-preview.LocationList<CR>
nnoremap <silent> [fzf-p]c  :<C-u>CocCommand fzf-preview.CommandPalette<CR>
nnoremap <silent> <F6>      :<C-u>CocCommand fzf-preview.DirectoryFiles ~/dotfiles/<CR>
