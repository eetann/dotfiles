# pnpmのグローバル設定(サプライチェーンアタック対策のminimumReleaseAge)。
# pnpm v11以降、認証・レジストリ以外の設定は~/.npmrcではなく専用のYAML
# 設定ファイルに書く必要があり、XDG_CONFIG_HOME未設定時のデフォルトパスは
# OSごとに異なる:
#   macOS: ~/Library/Preferences/pnpm/config.yaml
#   Linux: ~/.config/pnpm/config.yaml
# 実体は1つ(~/dotfiles/pnpm/config.yaml)にまとめ、OSごとに異なる
# シンボリックリンク先から参照させる。
{
  config,
  pkgs,
  lib,
  ...
}:
let
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";
  pnpmConfigSource = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/pnpm/config.yaml";
in
{
  home.file = lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
    "Library/Preferences/pnpm/config.yaml".source = pnpmConfigSource;
  };

  xdg.configFile = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    "pnpm/config.yaml".source = pnpmConfigSource;
  };
}
