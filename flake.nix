{
  description = "All in Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-26.05";

    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix-stable = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote-stable = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    impermanence.url = "github:nix-community/impermanence";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-stable = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowm-stable = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-stable = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    plasma-manager-stable = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.home-manager.follows = "home-manager-stable";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix-stable = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nixvim.url = "github:nix-community/nixvim";
    nixvim-stable.url = "github:nix-community/nixvim/nixos-26.05";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix-stable = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database-stable = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      inherit (inputs)
        self
        nixpkgs
        nixpkgs-stable
        home-manager
        home-manager-stable
        treefmt-nix
        ;
      inherit (self) outputs;

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Import hosts/<hostname>/meta.nix and inject hostname into the result
      readHostMeta = hostname: import (./hosts + "/${hostname}/meta.nix") // { inherit hostname; };

      # All host directory names that contain a meta.nix file
      allHosts = builtins.filter (
        hostname:
        let
          hostDir = ./hosts + "/${hostname}";
        in
        (builtins.readDir ./hosts).${hostname} == "directory" && builtins.pathExists (hostDir + "/meta.nix")
      ) (builtins.attrNames (builtins.readDir ./hosts));

      # Usernames declared under hosts/<hostname>/users
      usersForHost =
        hostPath:
        let
          usersDir = hostPath + "/users";
        in
        if builtins.pathExists usersDir then
          builtins.filter (u: (builtins.readDir usersDir).${u} == "directory") (
            builtins.attrNames (builtins.readDir usersDir)
          )
        else
          [ ];

      # Flat list of every { hostname, username } pair across all hosts
      allUserSlots = nixpkgs.lib.concatLists (
        map (
          hostname:
          let
            hostPath = ./hosts + "/${hostname}";
          in
          map (username: { inherit hostname username; }) (usersForHost hostPath)
        ) allHosts
      );

      # Select the appropriate nixpkgs, home-manager lib, and module sets by channel
      selectNixpkgs = meta: if meta.channel == "stable" then nixpkgs-stable else nixpkgs;
      selectHmLib = meta: if meta.channel == "stable" then home-manager-stable.lib else home-manager.lib;
      selectOsModules = meta: if meta.channel == "stable" then osModules.stable else osModules.unstable;
      selectHmModules = meta: if meta.channel == "stable" then hmModules.stable else hmModules.unstable;

      baseOsModulePath = ./modules/base/os;
      baseHmModulePath = ./modules/base/home;

      osModules = {
        unstable = with inputs; [
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          lanzaboote.nixosModules.lanzaboote
          stylix.nixosModules.stylix
        ];
        stable = with inputs; [
          home-manager-stable.nixosModules.home-manager
          sops-nix-stable.nixosModules.sops
          lanzaboote-stable.nixosModules.lanzaboote
          stylix-stable.nixosModules.stylix
        ];
      };

      hmModules = {
        unstable = with inputs; [
          sops-nix.homeManagerModules.sops
          niri.homeModules.niri
          niri.homeModules.stylix
          mangowm.hmModules.mango
          noctalia.homeModules.default
          plasma-manager.homeModules.plasma-manager
          stylix.homeModules.stylix
          nixvim.homeModules.nixvim
          spicetify-nix.homeManagerModules.default
          nix-index-database.homeModules.nix-index
        ];
        stable = with inputs; [
          sops-nix-stable.homeManagerModules.sops
          niri-stable.homeModules.niri
          niri-stable.homeModules.stylix
          mangowm-stable.hmModules.mango
          noctalia-stable.homeModules.default
          plasma-manager-stable.homeModules.plasma-manager
          stylix-stable.homeModules.stylix
          nixvim-stable.homeModules.nixvim
          spicetify-nix-stable.homeManagerModules.default
          nix-index-database-stable.homeModules.nix-index
        ];
      };

      mkTreefmtEval =
        system:
        treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} {
          projectRootFile = "flake.nix";
          programs = {
            nixfmt.enable = true;
            shfmt.enable = true;
            stylua.enable = true;
            taplo.enable = true;
            prettier.enable = true;
          };
        };

      mkNixosConfig =
        hostname:
        let
          hostPath = ./hosts + "/${hostname}";
          meta = readHostMeta hostname;
          channel = selectNixpkgs meta;
          lib = channel.lib;
          mylib = import ./lib { inherit lib; };
          hostUsers = usersForHost hostPath;
        in
        {
          name = hostname;
          value = lib.nixosSystem {
            system = meta.system;
            specialArgs = {
              inherit
                inputs
                outputs
                mylib
                meta
                ;
            };
            modules = [
              baseOsModulePath
              {
                home-manager.extraSpecialArgs = { inherit inputs outputs mylib; };
                home-manager.users = lib.genAttrs hostUsers (
                  username:
                  let
                    userPath = hostPath + "/users/${username}";
                  in
                  {
                    imports = [
                      baseHmModulePath
                    ]
                    ++ (selectHmModules meta)
                    ++ lib.optional (builtins.pathExists (userPath + "/imports.nix")) (userPath + "/imports.nix")
                    ++ lib.optional (builtins.pathExists (userPath + "/options.nix")) (userPath + "/options.nix");

                    home = {
                      username = username;
                      homeDirectory = "/home/${username}";
                      stateVersion = meta.stateVersion;
                    };
                    programs.home-manager.enable = true;
                    _module.args.meta = meta // {
                      inherit username;
                    };
                  }
                );

                system.stateVersion = meta.stateVersion;
              }
              {
                nixpkgs = {
                  overlays = import ./overlays { inherit inputs; };
                  config.allowUnfree = meta.allowUnfree;
                };
              }
            ]
            ++ (selectOsModules meta)
            ++ lib.optional (builtins.pathExists (hostPath + "/imports.nix")) (hostPath + "/imports.nix")
            ++ lib.optional (builtins.pathExists (hostPath + "/options.nix")) (hostPath + "/options.nix")
            ++ lib.optional (builtins.pathExists (hostPath + "/hardware-configuration.nix")) (
              hostPath + "/hardware-configuration.nix"
            );
          };
        };

      mkHomeConfig =
        { hostname, username }:
        let
          hostPath = ./hosts + "/${hostname}";
          userPath = hostPath + "/users/${username}";
          meta = readHostMeta hostname // {
            inherit username;
          };
          channel = selectNixpkgs meta;
          lib = channel.lib;
          mylib = import ./lib { inherit lib; };
          pkgs = import channel {
            inherit (meta) system;
            overlays = import ./overlays { inherit inputs; };
            config.allowUnfree = meta.allowUnfree;
          };
          # osConfig is null for non-NixOS hosts
          nixosConfig = outputs.nixosConfigurations.${hostname} or null;
          osConfig = if nixosConfig != null then nixosConfig.config else null;
        in
        {
          name = "${username}@${hostname}";
          value = (selectHmLib meta).homeManagerConfiguration {
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
              baseHmModulePath
              {
                home = {
                  inherit username;
                  homeDirectory = "/home/${username}";
                  stateVersion = meta.stateVersion;
                };
                programs.home-manager.enable = true;
              }
            ]
            ++ (selectHmModules meta)
            ++ lib.optional (builtins.pathExists (userPath + "/imports.nix")) (userPath + "/imports.nix")
            ++ lib.optional (builtins.pathExists (userPath + "/options.nix")) (userPath + "/options.nix");
          };
        };

      mkDevShells =
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = import ./overlays { inherit inputs; };
          };
        in
        import ./shells { inherit pkgs; };

      mkFormatter = system: (mkTreefmtEval system).config.build.wrapper;

      mkChecks =
        system:
        let
          hostsForSystem = builtins.filter (h: (readHostMeta h).system == system) allHosts;
          slotsForSystem = builtins.filter (s: (readHostMeta s.hostname).system == system) allUserSlots;
          treefmtEval = mkTreefmtEval system;
        in
        nixpkgs.lib.listToAttrs (
          map (hostname: {
            name = "nixosConfigurations:${hostname}";
            value = self.nixosConfigurations.${hostname}.config.system.build.toplevel;
          }) hostsForSystem
        )
        // nixpkgs.lib.listToAttrs (
          map (slot: {
            name = "homeConfigurations:${slot.username}@${slot.hostname}";
            value = self.homeConfigurations."${slot.username}@${slot.hostname}".activationPackage;
          }) slotsForSystem
        )
        // {
          formatting = treefmtEval.config.build.check self;
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.listToAttrs (map mkNixosConfig allHosts);
      homeConfigurations = nixpkgs.lib.listToAttrs (map mkHomeConfig allUserSlots);
      devShells = forAllSystems mkDevShells;
      formatter = forAllSystems mkFormatter;
      checks = forAllSystems mkChecks;
    };
}
