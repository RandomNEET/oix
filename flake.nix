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
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
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
      nixpkgs-stable,
      home-manager,
      home-manager-stable,
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

      isExt = name: nixpkgs.lib.hasPrefix "ext" name;
      isWsl = name: nixpkgs.lib.hasPrefix "wsl" name;

      getOptions =
        name:
        let
          hostPath = ./hosts + "/${name}";
        in
        import (hostPath + "/options.nix") {
          inherit outputs;
          lib = nixpkgs.lib;
        };

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
          isStable = (opts.channel or "unstable") == "stable";
          channel = if isStable then nixpkgs-stable else nixpkgs;
          lib = channel.lib;
          mylib = import ./lib { inherit lib; };
          hmModule =
            if isStable then
              home-manager-stable.nixosModules.home-manager
            else
              home-manager.nixosModules.home-manager;
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
              hmModule
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
          isStable = (opts.channel or "unstable") == "stable";
          channel = if isStable then nixpkgs-stable else nixpkgs;
          lib = channel.lib;
          mylib = import ./lib { inherit lib; };
          hmLib = if isStable then inputs.home-manager-stable.lib else inputs.home-manager.lib;
          hmModule =
            if isStable then
              home-manager-stable.nixosModules.home-manager
            else
              home-manager.nixosModules.home-manager;
        in
        {
          inherit name;
          value = hmLib.homeManagerConfiguration {
            pkgs =
              if nixosConfig != null then
                nixosConfig.pkgs
              else
                import channel {
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
                    hmModule
                    { nixpkgs.config.allowUnfree = true; }
                  ];
                }).config.home-manager.sharedModules;
          };
        };

      devShells =
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = import ./overlays { inherit inputs; };
          };
        in
        import ./shells { inherit pkgs; };
    in
    {
      nixosConfigurations = nixpkgs.lib.listToAttrs (
        map mkHost (builtins.filter (name: !isExt name) hosts)
      );
      homeConfigurations = nixpkgs.lib.listToAttrs (map mkHome hosts);
      devShells = forAllSystems devShells;
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
