#!/bin/sh

if [[ $(uname -a) =~ Linux && $(uname -a) =~ microsoft ]]; then
    # /mnt/c/Users/hoge みたいな感じ
    home_for_dot=$(wslpath -u $(cmd.exe /c echo %HOMEPATH%) | sed -e "s/[\r\n]\+//g")
    ln -fs ${home_for_dot}/ ${HOME}/myhome
else
    home_for_dot=${HOME}
fi

dot_dir=${home_for_dot}/dotfiles
ln -fs ${dot_dir} ${HOME}/dotfiles
for f in .??*
do
    #無視したいファイルやディレクトリ
    [ "$f" = ".git" ] && continue
    [ "$f" = ".config" ] && continue
    [ "$f" = ".vim" ] && continue
    ln -fs ${dot_dir}/${f} ${HOME}/${f}
done

ln -fs ${dot_dir}/dotfiles/.flake8 ${HOME}/.config/flake8
ln -fs ${dot_dir}/dotfiles/atcoder/main.cpp `acc config-dir`/cpp/main.cpp
ln -fs ${dot_dir}/dotfiles/atcoder/template.json `acc config-dir`/cpp/template.json
mkdir -p ~/.config/pypoetry
for f in `find ./.config -type f`
do
    ln -fs ${home_for_dot}/dotfiles/${f:2} ${HOME}/${f:2}
done
