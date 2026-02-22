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
    claude-chill = {
      url = "github:davidbeesley/claude-chill";
    };
    agent-skills.url = "github:Kyure-A/agent-skills-nix";
    design-skills = {
      url = "github:mae616/design-skills";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }@inputs:
    let
      # 将来的にLinuxも対応できるように変数化
      system = "aarch64-darwin"; # Apple Silicon Mac
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # nix-darwin設定（darwin-rebuild switch --flake .#eetann-mac）
      darwinConfigurations."eetann-mac" = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./nix/darwin
          home-manager.darwinModules.home-manager
        ];
      };

      # home-manager単体（home-manager switch --flake . も引き続き動作）
      homeConfigurations."eetann" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          inputs.agent-skills.homeManagerModules.default
          ./nix/home
        ];
      };
    };
}
