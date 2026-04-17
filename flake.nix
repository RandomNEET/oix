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
    sops-nix-stable = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix-stable = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    impermanence.url = "github:nix-community/impermanence";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote-stable = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-stable = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-stable = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim-stable = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix-stable = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database-stable = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      home-manager-stable,
      sops-nix,
      sops-nix-stable,
      stylix,
      stylix-stable,
      lanzaboote,
      lanzaboote-stable,
      niri,
      niri-stable,
      noctalia,
      noctalia-stable,
      nixvim,
      nixvim-stable,
      spicetify-nix,
      spicetify-nix-stable,
      nix-index-database,
      nix-index-database-stable,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      allowUnfree = true;

      getMeta = hostname: import (./hosts + "/${hostname}/meta.nix");
      getHosts = builtins.filter (
        hostname:
        let
          hostPath = ./hosts + "/${hostname}";
          hasBase = builtins.pathExists (hostPath + "/meta.nix");
        in
        (builtins.readDir ./hosts).${hostname} == "directory" && hasBase
      ) (builtins.attrNames (builtins.readDir ./hosts));
      getUsers =
        hostPath:
        let
          usersPath = hostPath + "/users";
        in
        if builtins.pathExists usersPath then
          let
            contents = builtins.readDir usersPath;
          in
          builtins.filter (username: contents.${username} == "directory") (builtins.attrNames contents)
        else
          [ ];
      getHomes = nixpkgs.lib.concatLists (
        map (
          hostname:
          let
            hostPath = ./hosts + "/${hostname}";
            users = getUsers hostPath;
          in
          map (username: { inherit hostname username; }) users
        ) getHosts
      );

      baseModules = {
        os = ./modules/base;
        home = ./modules/home/base;
      };
      osUnstableModules = [
        home-manager.nixosModules.home-manager
        sops-nix.nixosModules.sops
        stylix.nixosModules.stylix
        lanzaboote.nixosModules.lanzaboote
      ];
      osStableModules = [
        home-manager-stable.nixosModules.home-manager
        sops-nix-stable.nixosModules.sops
        stylix-stable.nixosModules.stylix
        lanzaboote-stable.nixosModules.lanzaboote
      ];
      hmUnstableModules = [
        sops-nix.homeManagerModules.sops
        stylix.homeModules.stylix
        niri.homeModules.niri
        niri.homeModules.stylix
        noctalia.homeModules.default
        nixvim.homeModules.nixvim
        spicetify-nix.homeManagerModules.default
        nix-index-database.homeModules.nix-index
      ];
      hmStableModules = [
        sops-nix-stable.homeManagerModules.sops
        stylix-stable.homeModules.stylix
        niri-stable.homeModules.niri
        niri-stable.homeModules.stylix
        noctalia-stable.homeModules.default
        nixvim-stable.homeModules.nixvim
        spicetify-nix-stable.homeManagerModules.default
        nix-index-database-stable.homeModules.nix-index
      ];

      mkHost =
        hostname:
        let
          hostPath = ./hosts + "/${hostname}";
          baseMeta = (getMeta hostname) // {
            inherit hostname;
          };
          isStable = baseMeta.channel == "stable";
          channel = if isStable then nixpkgs-stable else nixpkgs;
          lib = channel.lib;
          mylib = import ./lib { inherit lib; };
          hostUsers = getUsers hostPath;
        in
        {
          name = hostname;
          value = lib.nixosSystem {
            system = baseMeta.system;
            specialArgs = {
              inherit
                inputs
                outputs
                mylib
                ;
              meta = baseMeta;
            };
            modules = [
              baseModules.os
              {
                home-manager.extraSpecialArgs = {
                  inherit
                    inputs
                    outputs
                    mylib
                    ;
                };
                home-manager.users = lib.genAttrs hostUsers (username: {
                  imports = [
                    baseModules.home
                  ]
                  ++ (if isStable then hmStableModules else hmUnstableModules)
                  ++ lib.optionals (builtins.pathExists (hostPath + "/users/${username}/imports.nix")) [
                    (hostPath + "/users/${username}/imports.nix")
                  ]
                  ++ lib.optionals (builtins.pathExists (hostPath + "/users/${username}/options.nix")) [
                    (hostPath + "/users/${username}/options.nix")
                  ];
                  home = {
                    username = username;
                    homeDirectory = "/home/${username}";
                    stateVersion = baseMeta.stateVersion;
                  };
                  programs.home-manager.enable = true;
                  _module.args.meta = baseMeta // {
                    inherit username;
                  };
                });
                system.stateVersion = baseMeta.stateVersion;
              }
              {
                nixpkgs = {
                  overlays = import ./overlays { inherit inputs; };
                  config.allowUnfree = allowUnfree;
                };
              }
            ]
            ++ (if isStable then osStableModules else osUnstableModules)
            ++ lib.optionals (builtins.pathExists (hostPath + "/imports.nix")) [ (hostPath + "/imports.nix") ]
            ++ lib.optionals (builtins.pathExists (hostPath + "/options.nix")) [ (hostPath + "/options.nix") ]
            ++ lib.optionals (builtins.pathExists (hostPath + "/hardware-configuration.nix")) [
              (hostPath + "/hardware-configuration.nix")
            ];
          };
        };

      mkHome =
        { hostname, username }:
        let
          hostPath = ./hosts + "/${hostname}";
          userPath = hostPath + "/users/${username}";
          meta = (getMeta hostname) // {
            inherit hostname username;
          };
          isStable = meta.channel == "stable";
          channel = if isStable then nixpkgs-stable else nixpkgs;
          lib = channel.lib;
          mylib = import ./lib { inherit lib; };
          pkgs = import channel {
            inherit (meta) system;
            overlays = import ./overlays { inherit inputs; };
            config.allowUnfree = allowUnfree;
          };
          hmLib = if isStable then home-manager-stable.lib else home-manager.lib;
          nixosConfig = outputs.nixosConfigurations.${hostname} or null;
          osConfig = if nixosConfig != null then nixosConfig.config else null;
        in
        {
          name = "${username}-${hostname}";
          value = hmLib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit
                inputs
                outputs
                meta
                mylib
                osConfig
                ;
            };
            modules = [
              baseModules.home
              {
                home = {
                  inherit username;
                  homeDirectory = "/home/${username}";
                  stateVersion = meta.stateVersion;
                };
                programs.home-manager.enable = true;
              }
            ]
            ++ (if isStable then hmStableModules else hmUnstableModules)
            ++ lib.optionals (builtins.pathExists (userPath + "/imports.nix")) [ (userPath + "/imports.nix") ]
            ++ lib.optionals (builtins.pathExists (userPath + "/options.nix")) [ (userPath + "/options.nix") ];
          };
        };

      mkCheck =
        system:
        let
          hosts = builtins.filter (h: (getMeta h).system == system) getHosts;
          homes = builtins.filter (h: (getMeta h.hostname).system == system) getHomes;
        in
        (nixpkgs.lib.listToAttrs (
          map (hostname: {
            name = "nixosConfigurations:${hostname}";
            value = self.nixosConfigurations.${hostname}.config.system.build.toplevel;
          }) hosts
        ))
        // (nixpkgs.lib.listToAttrs (
          map (home: {
            name = "homeConfigurations:${home.username}-${home.hostname}";
            value = self.homeConfigurations."${home.username}-${home.hostname}".activationPackage;
          }) homes
        ));

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
      nixosConfigurations = nixpkgs.lib.listToAttrs (map mkHost getHosts);
      homeConfigurations = nixpkgs.lib.listToAttrs (map mkHome getHomes);
      checks = forAllSystems mkCheck;
      devShells = forAllSystems devShells;
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
