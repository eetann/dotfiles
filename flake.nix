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
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agent-skills.url = "github:Kyure-A/agent-skills-nix";
    ax = {
      url = "github:yusukebe/ax";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    design-skills = {
      url = "github:mae616/design-skills";
      flake = false;
    };
    playwright-cli-skills = {
      url = "github:microsoft/playwright-cli";
      flake = false;
    };
    drawio-mcp = {
      url = "github:jgraph/drawio-mcp";
      flake = false;
    };
    mattpocock-skills = {
      url = "github:mattpocock/skills";
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
      darwinSystem = "aarch64-darwin"; # Apple Silicon Mac
      linuxSystem = "x86_64-linux"; # NixOS-WSL
      darwinPkgs = nixpkgs.legacyPackages.${darwinSystem};
    in
    {
      # nix-darwin設定（darwin-rebuild switch --flake .#eetann-mac）
      darwinConfigurations."eetann-mac" = nix-darwin.lib.darwinSystem {
        system = darwinSystem;
        specialArgs = { inherit inputs; };
        modules = [
          ./nix/darwin
          home-manager.darwinModules.home-manager
        ];
      };

      # NixOS-WSL設定（nixos-rebuild switch --flake .#eetann-wsl）
      nixosConfigurations."eetann-wsl" = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        specialArgs = { inherit inputs; };
        modules = [
          inputs.nixos-wsl.nixosModules.wsl
          ./nix/nixos
          home-manager.nixosModules.home-manager
        ];
      };

      # home-manager単体（home-manager switch --flake . も引き続き動作）
      homeConfigurations."eetann" = home-manager.lib.homeManagerConfiguration {
        pkgs = darwinPkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          inputs.agent-skills.homeManagerModules.default
          ./nix/home
        ];
      };
    };
}
