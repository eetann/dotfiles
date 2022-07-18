vim.cmd([[
set errorformat=%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
let g:quickrun_config = {}
let g:quickrun_config = {
\ "_":{
\   'runner'    : 'neovim_job',
\   'runner/terminal/into':1,
\   'outputter' : 'error',
\   'outputter/error/success' : 'buffer',
\   'outputter/error/error'   : 'quickfix',
\   'outputter/buffer/close_on_empty' : 1,
\   'outputter/buffer/into':1,
\   'outputter/buffer/split'  :
\     '%{winwidth(0) * 2 < winheight(0) * 5 ? winheight(0)/4 : "vertical"}',
\   'outputter/quickfix/into':1,
\   },
\ 'markdown': {
\   'runner'    : 'vimscript',
\   'exec':'%c %a',
\   'command': ":call",
\   'args': 'My_opens()',
\   'outputter':'null',
\ },
\   'html': {
\   'runner'    : 'vimscript',
\   'exec':'%c %a',
\   'command': ":call",
\   'args': 'My_opens()',
\   'outputter':'null',
\ },
\   'tex': {
\   'command': 'latexmk',
\   'args':'-pvc',
\   'exec':'%c %a %s',
\ },
\}
command! -nargs=+ -complete=command Capture QuickRun -type vim -src <q-args>
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
]])

vim.keymap.set("n", "<leader>r", "<Cmd>:write<CR>:QuickRun -mode n<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>R", "<Cmd>:write<CR>:QuickRun -runner terminal<CR>", { noremap = true, silent = true })
vim.keymap.set("x", "<leader>r", ":<C-U>write<CR>gv:QuickRun -mode v<CR>", { noremap = true, silent = true })
