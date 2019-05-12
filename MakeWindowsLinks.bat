REM  管理者権限でコマンドプロンプトを実行
cd ..
mkdir .vim
mkdir .vim\dein
mklink .vimrc dotfiles\.vimrc
mklink .vim\coc-settings.json ..\dotfiles\vim\coc-settings.json
