# nix-darwinのエントリポイント
#
# darwin-rebuild switch --flake .#eetann-mac で適用
{ ... }:
{
  imports = [
    ./nix.nix
    ./system.nix
  ];

  # ホスト名を統一（ターミナル、共有、Bonjour全て）
  networking.hostName = "eetann-mac";
  networking.computerName = "eetann-mac";
  networking.localHostName = "eetann-mac";

  # ↓を指定しないとtmuxのpopupで使えない
  environment.systemPath = [ "/opt/homebrew/bin" ];

  # エディタをnvimに設定（デフォルトはnano）
  environment.variables.EDITOR = "nvim";

  # システム設定を適用するユーザー
  system.primaryUser = "eetann";

  # ユーザー設定（home-managerがhomeDirectoryを取得するために必要）
  users.users.eetann = {
    name = "eetann";
    home = "/Users/eetann";
  };

  # home-manager統合
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.eetann = import ../home;
}
