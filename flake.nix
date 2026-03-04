{
  description = "All in Nix";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
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

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

      lib = nixpkgs.lib;
      mylib = import ./lib { inherit lib; };

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = lib.genAttrs systems;

      isExt = name: lib.hasPrefix "ext" name;
      isWsl = name: lib.hasPrefix "wsl" name;

      getOptions =
        name:
        let
          hostPath = ./hosts + "/${name}";
        in
        import (hostPath + "/options.nix") { inherit outputs lib; };

      hosts = builtins.filter (
        name:
        let
          hostPath = ./hosts + "/${name}";
          hasBase =
            builtins.pathExists (hostPath + "/default.nix") && builtins.pathExists (hostPath + "/options.nix");
          hasHardware = builtins.pathExists (hostPath + "/hardware-configuration.nix");
        in
        (builtins.readDir ./hosts).${name} == "directory"
        && hasBase
        && (hasHardware || isWsl name || isExt name)
      ) (builtins.attrNames (builtins.readDir ./hosts));

      mkHost =
        name:
        let
          host = ./hosts + "/${name}";
          opts = getOptions name;
        in
        {
          inherit name;
          value = lib.nixosSystem {
            system = opts.system;
            specialArgs = {
              inherit
                inputs
                outputs
                mylib
                opts
                ;
              hostname = name;
              isExt = isExt name;
              isWsl = isWsl name;
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
                  hostname = name;
                  isExt = isExt name;
                  isWsl = isWsl name;
                };
              }
              { nixpkgs.overlays = import ./overlays { inherit inputs; }; }
            ]
            ++ lib.optionals (isWsl name) [
              nixos-wsl.nixosModules.default
              { wsl.enable = true; }
            ]
            ++ lib.optionals (builtins.pathExists (host + "/hardware-configuration.nix")) [
              (host + "/hardware-configuration.nix")
            ];
          };
        };

      mkHome =
        name:
        let
          nixosConfig = self.nixosConfigurations.${name} or null;
          opts = getOptions name;
        in
        {
          inherit name;
          value = home-manager.lib.homeManagerConfiguration {
            pkgs =
              if nixosConfig != null then
                nixosConfig.pkgs
              else
                import nixpkgs {
                  system = opts.system;
                  config.allowUnfree = true;
                  overlays = import ./overlays { inherit inputs; };
                };
            extraSpecialArgs = {
              osConfig = if nixosConfig != null then nixosConfig.config else (opts.osConfig or { });
              inherit
                inputs
                outputs
                mylib
                opts
                ;
              hostname = name;
              isExt = isExt name;
              isWsl = isWsl name;
            };
            modules =
              (
                if nixosConfig != null then
                  nixosConfig.config.home-manager.sharedModules
                else
                  (lib.nixosSystem {
                    inherit (opts) system;
                    specialArgs = {
                      inherit
                        inputs
                        outputs
                        mylib
                        opts
                        ;
                      hostname = name;
                      isWsl = isWsl name;
                      isExt = isExt name;
                    };
                    modules = [
                      (./hosts + "/${name}")
                      home-manager.nixosModules.home-manager
                      { nixpkgs.config.allowUnfree = true; }
                    ];
                  }).config.home-manager.sharedModules
              )
              ++ [
                (
                  { lib, pkgs, ... }:
                  {
                    programs.home-manager.enable = true;
                    home = opts.home or { };
                    nix.package = lib.mkDefault pkgs.nix;
                    nixpkgs.overlays = lib.mkForce null;
                    nixpkgs.config.allowUnfree = lib.mkForce true;
                  }
                )
              ];
          };
        };
    in
    {
      nixosConfigurations = lib.listToAttrs (map mkHost (builtins.filter (name: !isExt name) hosts));
      homeConfigurations = lib.listToAttrs (map mkHome hosts);
      formatter = forAllSystems (system: lib.nixos-tree or nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
