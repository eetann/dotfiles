# zsh プラグインを~/.zsh/plugins/に配置
{ pkgs, ... }:
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

  # nixpkgsにないプラグイン
  home.file.".zsh/plugins/zeno".source = zeno-zsh;

  # zsh-completionsはfpath用（補完定義群）
  home.file.".zsh/completions".source = "${pkgs.zsh-completions}/share/zsh/site-functions";
}
