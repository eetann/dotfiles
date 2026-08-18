# npm/bun等でグローバルインストールした非Nixビルドのバイナリ（Playwright等）は
# 標準的なFHSパス(/usr/lib等)に共有ライブラリがある前提でリンクされており、
# NixOSではそのままでは動的リンカがライブラリを見つけられず実行できない。
# nix-ldで動的リンカと共有ライブラリの探索先を補う
{ pkgs, ... }:
{
  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    # Playwright(Chromium)が要求する共有ライブラリ一式
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/web/playwright/chromium.nix
    alsa-lib
    at-spi2-atk
    atk
    cairo
    cups
    dbus
    expat
    glib
    gobject-introspection
    libgbm
    libxkbcommon
    nspr
    nss
    pango
    stdenv.cc.cc.lib
    systemd
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxcb
    libGL
    vulkan-loader
    pciutils
  ];
}
