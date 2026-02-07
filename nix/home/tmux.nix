# tmux プラグイン設定
# programs.tmuxは使わず、プラグインを~/.tmux/plugins/に配置
{ pkgs, config, ... }:
let
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";
in
{
  # プラグインを~/.tmux/plugins/に配置（tpmと同じ構造）
  home.file.".tmux/plugins/resurrect".source =
    "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect";
  home.file.".tmux/plugins/continuum".source =
    "${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum";

  # 設定ファイルはシンボリックリンク管理を維持
  home.file.".tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.tmux.conf";
}
