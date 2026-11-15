# GitHub CLI(gh)本体と拡張機能の管理。
# programs.gh を有効にすると ~/.config/gh/config.yml がhome-manager管理
# (Nix storeへの読み取り専用リンク)になるため、`gh config set` は使えない。
# 設定は settings に書く。認証情報の hosts.yml は管理対象外。
# 拡張機能は `gh extension install` ではなく extensions に追加する。
{ pkgs, ... }:
{
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      aliases = {
        co = "pr checkout";
      };
    };
    extensions = with pkgs; [
      gh-actions-lock # ワークフローの依存をロックする
    ];
  };
}
