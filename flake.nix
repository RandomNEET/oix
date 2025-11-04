{
  description = "howl's flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      hosts = builtins.filter (n: builtins.pathExists (./hosts + "/${n}/options.nix")) (
        builtins.attrNames (builtins.readDir ./hosts)
      );
      mkHost =
        name:
        let
          hostPath = ./hosts + "/${name}";
          opts = import (hostPath + "/options.nix");
        in
        {
          name = opts.hostname;
          value = nixpkgs.lib.nixosSystem {
            system = opts.system;
            specialArgs = { inherit inputs opts; };
            modules = [
              hostPath
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { inherit inputs outputs opts; };
              }
              {
                nixpkgs.overlays = import ./overlays { inherit inputs opts; };
              }
            ];
          };
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.listToAttrs (map mkHost hosts);
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
