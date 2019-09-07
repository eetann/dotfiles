#!/bin/sh

if [[ $(uname -a) =~ Linux && $(uname -a) =~ Microsoft ]]; then
    # /mnt/c/Users/hoge みたいな感じ
    home_for_dot=$(wslpath -u $(cmd.exe /c echo %HOMEPATH%) | sed -e "s/[\r\n]\+//g")
    ln -fs ${home_for_dot}/ ${HOME}/myhome
    ln -fs ${home_for_dot}/.vim ${HOME}/.vim
else
    home_for_dot=${HOME}
fi

dot_directory=${home_for_dot}/dotfiles
for f in .??*
do
    #無視したいファイルやディレクトリ
    [ "$f" = ".git" ] && continue
    [ "$f" = ".config" ] && continue
    [ "$f" = ".vim" ] && continue
    ln -fs ${dot_directory}/${f} ${HOME}/${f}
done

# ln -s ${home_for_dot}/dotfiles/flake8 ${HOME}/.config/flake8
for f in `find ./.config -type f`
do
    ln -fs ${home_for_dot}/dotfiles/${f:2} ${HOME}/${f:2}
done
