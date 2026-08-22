# NixOS-WSLのエントリポイント
#
# 初回: sudo nixos-rebuild switch --flake .#eetann-wsl --extra-experimental-features "nix-command flakes"
# 以降: sudo nixos-rebuild switch --flake .#eetann-wsl
{ inputs, pkgs, ... }:
{
  imports = [
    ./nix.nix
    ./allow-unfree.nix
    ./nix-ld.nix
    ./docker.nix
    ./ca-certificates.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "eetann";

  networking.hostName = "eetann-wsl";

  # エディタをnvimに設定（デフォルトはnano）
  environment.variables.EDITOR = "nvim";

  # 高速起動のため自前で処理するので不要（nix-darwin側と同じ方針）
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = false;
  programs.zsh.promptInit = "";

  users.users.eetann = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # sudo可能にする
      "docker" # dockerコマンドをsudoなしで実行可能にする
    ];
    shell = pkgs.zsh;
  };

  # home-manager統合
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.users.eetann = {
    imports = [
      inputs.agent-skills.homeManagerModules.default
      (import ../home)
    ];
  };

  # NixOSのバージョン管理。
  # 初回インストール時の /etc/nixos/configuration.nix にある system.stateVersion の値を
  # そのままコピーすること（変更すると意図しない挙動になりうる）
  system.stateVersion = "25.05"; # TODO: 実機の値で上書き
}
