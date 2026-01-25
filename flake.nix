{
  description = "eetann's dotfiles managed by home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      # 将来的にLinuxも対応できるように変数化
      system = "aarch64-darwin"; # Apple Silicon Mac
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."eetann" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
}
