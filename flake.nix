{
  description = "I use nixos btw";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-25.11";
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
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-wsl,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      isWsl =
        name:
        builtins.elem name [
          "wsl"
          "wix"
        ];
      hosts = builtins.filter (
        name:
        let
          hostPath = ./hosts + "/${name}";
          hasBase =
            builtins.pathExists (hostPath + "/default.nix") && builtins.pathExists (hostPath + "/options.nix");
          hasHardware = builtins.pathExists (hostPath + "/hardware-configuration.nix");
        in
        (builtins.readDir ./hosts).${name} == "directory" && hasBase && (hasHardware || isWsl name)
      ) (builtins.attrNames (builtins.readDir ./hosts));
      mkHost =
        name:
        let
          lib = nixpkgs.lib;
          host = ./hosts + "/${name}";
          mylib = import ./lib { inherit lib; };
          opts = import (host + "/options.nix") { inherit outputs lib; };
        in
        {
          inherit name;
          value = nixpkgs.lib.nixosSystem {
            system = opts.system;
            specialArgs = {
              inherit
                inputs
                outputs
                mylib
                opts
                ;
            };
            modules = [
              host
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {
                  inherit
                    inputs
                    outputs
                    mylib
                    opts
                    ;
                };
              }
              {
                nixpkgs.overlays = import ./overlays { inherit inputs; };
              }
            ]
            ++ (
              if (isWsl name) then
                [
                  nixos-wsl.nixosModules.default
                  { wsl.enable = true; }
                ]
              else
                [
                  (host + "/hardware-configuration.nix")
                ]
            );
          };
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.listToAttrs (map mkHost hosts);
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
