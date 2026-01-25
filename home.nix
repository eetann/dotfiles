# home-managerによるdotfiles管理
#
# mkOutOfStoreSymlinkを使用することで、設定ファイルの編集が即座に反映される。
# （通常のhome.fileだとhome-manager switchを実行するまで反映されない）
#
# シンボリックリンクは3段階になる:
#   ~/.config/nvim
#     → /nix/store/.../home-manager-files/.config/nvim
#       → /nix/store/.../hm_nvim
#         → ~/dotfiles/.config/nvim  ← 最終的にここを指す
#
{ config, pkgs, ... }:

let
  # mkOutOfStoreSymlinkを使うため、絶対パス文字列が必要
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";

  # home.file用ヘルパー: リストから { "name".source = mkOutOfStoreSymlink ... } を生成
  mkHomeFile = name: {
    name = name;
    value = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${name}";
    };
  };
  mkHomeFiles = files: builtins.listToAttrs (map mkHomeFile files);

  # xdg.configFile用ヘルパー: リストから { "name".source = mkOutOfStoreSymlink .config/... } を生成
  mkConfigFile = name: {
    name = name;
    value = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/${name}";
    };
  };
  mkConfigFiles = files: builtins.listToAttrs (map mkConfigFile files);

in
{
  home.username = "eetann";
  home.homeDirectory = "/Users/eetann";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # home-managerで管理するパッケージ
  home.packages = [
    pkgs.nixfmt-rfc-style
  ];

  # ホームディレクトリ直下のdotfiles
  home.file = mkHomeFiles [
    ".clang-format"
    ".latexmkrc"
    ".tmux.conf"
    ".zshrc"
    ".claude/commands"
    ".claude/agents"
    ".codex/prompts"
  ];

  # ~/.config 配下のファイル
  xdg.configFile = mkConfigFiles [
    "efm-langserver"
    "nvim"
    "alacritty"
    "rofi"
    "git"
    "wezterm"
    "zeno"
    "i3/config"
    "lazygit/config.yml"
  ];
}
