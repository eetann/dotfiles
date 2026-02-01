{
  description = "eetann's dotfiles managed by nix-darwin + home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      # 将来的にLinuxも対応できるように変数化
      system = "aarch64-darwin"; # Apple Silicon Mac
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # nix-darwin設定（darwin-rebuild switch --flake .#eetann-mac）
      darwinConfigurations."eetann-mac" = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./nix/darwin
          home-manager.darwinModules.home-manager
        ];
      };

      # home-manager単体（home-manager switch --flake . も引き続き動作）
      homeConfigurations."eetann" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./nix/home ];
      };
    };
}
