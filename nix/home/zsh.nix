# zsh プラグイン設定
# oh-my-zshを排除し、プラグインを~/.zsh/plugins/に配置
{ pkgs, ... }:
let
  # nixpkgsにないプラグイン
  zeno-zsh = pkgs.fetchFromGitHub {
    owner = "yuki-yano";
    repo = "zeno.zsh";
    rev = "e790867f6d7abdf8c71cc441c669b985b6e079e1";
    hash = "sha256-51BGfcKN0NtZ52ysATp3DjfhKZwvipBiKi09vd+Q/ZY=";
  };
in
{
  # nixpkgsのプラグインを~/.zsh/plugins/に配置
  home.file.".zsh/plugins/zsh-autosuggestions".source =
    "${pkgs.zsh-autosuggestions}/share/zsh/plugins/zsh-autosuggestions";
  home.file.".zsh/plugins/fast-syntax-highlighting".source =
    "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting";
  home.file.".zsh/plugins/zsh-history-substring-search".source =
    "${pkgs.zsh-history-substring-search}/share/zsh/plugins/zsh-history-substring-search";
  home.file.".zsh/plugins/powerlevel10k".source =
    "${pkgs.zsh-powerlevel10k}/share/zsh/themes/powerlevel10k";
  home.file.".zsh/plugins/fzf".source = "${pkgs.fzf}/share/fzf";

  # nixpkgsにないプラグイン
  home.file.".zsh/plugins/zeno".source = zeno-zsh;

  # zsh-completionsはfpath用（補完定義群）
  home.file.".zsh/completions".source =
    "${pkgs.zsh-completions}/share/zsh/site-functions";
}
