# tmux プラグイン設定
# programs.tmuxは使わず、プラグインを~/.tmux/plugins/に配置
{ pkgs, config, ... }:
let
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";

  # opensessionsはbun installが必要なため、Nix store外にコピーして実行する
  opensessionsRev = "8eed564e863e9c115f16a5d67370cc6223009b64";
  opensessionsSrc = pkgs.fetchFromGitHub {
    owner = "Ataraxy-Labs";
    repo = "opensessions";
    rev = opensessionsRev;
    hash = "sha256-JSJx9Rx/SunS46/IFB/ytmKBElZtbrymKODl2GBGVUI=";
  };
  opensessionsDir = "${config.home.homeDirectory}/.local/share/opensessions";
  opensessionsScript = pkgs.writeShellScript "opensessions-init.sh" ''
    target="${opensessionsDir}"
    stamp="$target/.version"

    # revが変わった時だけコピーし直す（node_modulesも消える→bun installが再実行される）
    if [ ! -f "$stamp" ] || [ "$(cat "$stamp" 2>/dev/null)" != "${opensessionsRev}" ]; then
      rm -rf "$target"
      cp -R "${opensessionsSrc}" "$target"
      chmod -R u+w "$target"
      printf '%s' "${opensessionsRev}" > "$stamp"
    fi

    exec "$target/opensessions.tmux"
  '';
in
{
  # プラグインを~/.tmux/plugins/に配置（tpmと同じ構造）
  home.file.".tmux/plugins/resurrect".source =
    "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect";
  home.file.".tmux/plugins/continuum".source =
    "${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum";

  # opensessionsは初期化スクリプトをプラグインディレクトリに配置
  home.file.".tmux/plugins/opensessions/opensessions.tmux" = {
    source = opensessionsScript;
    executable = true;
  };

  # 設定ファイルはシンボリックリンク管理を維持
  home.file.".tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.tmux.conf";
}
