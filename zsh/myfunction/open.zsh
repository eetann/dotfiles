if [[ "$(uname -r)" == *microsoft* ]]; then
  function open() {
    if [ $# != 1 ]; then
      /mnt/c/windows/explorer.exe .
    else
      if [ -e $1 ]; then
        /mnt/c/windows/explorer.exe $(wslpath -w $1)
      else
        echo "open: $1 : No such file or directory"
      fi
    fi
  }
fi
