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

  # home-manager統合
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.eetann = import ../home;
}
