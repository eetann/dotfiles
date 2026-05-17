# zsh プラグインを~/.zsh/plugins/に配置
{ pkgs, lib, ... }:
let
  # nixpkgsにないプラグイン
  zeno-zsh = pkgs.fetchFromGitHub {
    owner = "yuki-yano";
    repo = "zeno.zsh";
    rev = "2e8fbecce0fc3692a5fcc9033ecca7ab35263e56";
    hash = "sha256-05+w1WP/SHKp97JTGsvO3csI123U7py+fVSKnAWiUNY=";
  };
in
{
  # nixpkgsのプラグインを~/.zsh/plugins/に配置
  home.file.".zsh/plugins/zsh-autosuggestions".source =
    "${pkgs.zsh-autosuggestions}/share/zsh/plugins/zsh-autosuggestions";
  home.file.".zsh/plugins/fast-syntax-highlighting".source =
    "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting";
  home.file.".zsh/plugins/powerlevel10k".source =
    "${pkgs.zsh-powerlevel10k}/share/zsh/themes/powerlevel10k";
  home.file.".zsh/plugins/fzf".source = "${pkgs.fzf}/share/fzf";

  # zenoはdenoを `--node-modules-dir=auto` で起動するため、
  # deno.jsonと同じ場所(=ソースディレクトリ)に node_modules を書き込もうとする。
  # /nix/store は読み取り専用なので symlink ではなく書き込み可能なコピーとして配置する。
  home.activation.installZeno = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run rm -rf "$HOME/.zsh/plugins/zeno"
    run cp -r ${zeno-zsh} "$HOME/.zsh/plugins/zeno"
    run chmod -R u+w "$HOME/.zsh/plugins/zeno"
  '';

  # zsh-completionsはfpath用（補完定義群）
  home.file.".zsh/completions".source = "${pkgs.zsh-completions}/share/zsh/site-functions";
}
