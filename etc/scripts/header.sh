#!/usr/bin/env bash

tput=$(which tput)
if [ -n "$tput" ]; then
  ncolors=$($tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  NORMAL=""
fi

info() { 
  printf "%s" "$GREEN"
  echo -n "[+] "
  printf "%s" "$NORMAL"
  echo "$1"
}

error() {
  printf "%s" "$RED"
  echo -n "[-] "
  printf "%s" "$NORMAL"
  echo "$1"
}

warn() {
  printf "%s" "$YELLOW"
  echo -n "[*] "
  printf "%s" "$NORMAL"
  echo "$1"
}

log() { 
  echo "  $1" 
}

is_exists() {
    which "$1" >/dev/null 2>&1
    return $?
}

has() {
  type "$1" > /dev/null 2>&1
}

detect_os() {
  case "$(uname -s)" in
    Linux|GNU*)
      linux_distribution ;;
    Darwin)
      echo darwin ;;
    Windows|CYGWIN*|MSYS*|MINGW*)
      echo windows ;;
    *)
      echo unknown ;;
  esac
}

linux_distribution() {
  if [ -f /etc/debian_version ]; then
    if [ "$(awk -F= '/DISTRIB_ID/ {print $2}' /etc/lsb-release)" = "Ubuntu" ]; then
      echo ubuntu
    else
      echo debian
    fi
  elif [ -f /etc/arch-release ]; then
    echo archlinux
  elif [[ -d /system/app/ && -d /system/priv-app ]]; then
    echo android
  else
    echo unkown_linux
  fi
