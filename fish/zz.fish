function zz
    set dir (z -l $argv | cut -b12- | tac | fzf  --height=60% --select-1 --exit-0 --reverse --no-unicode --preview 'tree -al {} | head -n 100')
    if [ $dir ]
        cd $dir
    end
    commandline -f repaint
end
