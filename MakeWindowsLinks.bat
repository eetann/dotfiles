cd ..
mkdir .vim
mkdir .vim\dein
cmd /c mklink .vimrc dotfiles\.vimrc
cmd /c mklink /J .vim\dein\userconfig dotfiles\userconfig
