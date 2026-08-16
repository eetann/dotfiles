# NixOS-WSLには/usr/share/dict/wordsが無いため、
# blink-cmp-dictionary用にmiscfilesのweb2(Webster's Second)を配置する。
# macOSの/usr/share/dict/wordsもweb2へのシンボリックリンクなので、
# 両OSで同じ単語リストになる。
{ pkgs, lib, ... }:
{
  home.file = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    ".local/share/dict/words".source = "${pkgs.miscfiles}/share/web2";
  };
}
