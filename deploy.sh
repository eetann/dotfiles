#!/bin/sh

if [[ $(uname -a) =~ Linux && $(uname -a) =~ microsoft ]]; then
    # /mnt/c/Users/hoge みたいな感じ
    home_for_dot=$(wslpath -u $(cmd.exe /c echo %HOMEPATH%) | sed -e "s/[\r\n]\+//g")
    ln -fs ${home_for_dot}/ ${HOME}/myhome
    dot_dir=${home_for_dot}/dotfiles
    ln -fs ${dot_dir} ${HOME}/dotfiles
else
    home_for_dot=${HOME}
    dot_dir=${home_for_dot}/dotfiles
fi
echo ${dot_dir}
read -p "dotfilesのフルパスは正しいですか? (y/n) :" YN
if [ "${YN}" = "y" ]; then
    echo "処理を進めます"
else
    echo "シェルスクリプトを更新してください"
    exit 1;
fi

for f in `find ~/dotfiles/. -maxdepth 1 -type f -name ".*" | gawk -F/ '{print $NF}'`
do
    ln -fs ${dot_dir}/${f} ${HOME}/${f}
done

ln -fs ${dot_dir}/dotfiles/.flake8 ${HOME}/.config/flake8
cp ${dot_dir}/dotfiles/atcoder/main.cpp `acc config-dir`/cpp
cp ${dot_dir}/dotfiles/atcoder/template.json `acc config-dir`/cpp
mkdir -p ~/.config/pypoetry
for f in `find ./.config -type f`
do
    ln -fs ${home_for_dot}/dotfiles/${f:2} ${HOME}/${f:2}
done
