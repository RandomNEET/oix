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
    nixos-wsl.url = "github:nix-community/NixOS-WSL";

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
    nix-flatpak.url = "github:gmodena/nix-flatpak";

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

      getMeta = hostname: import (./hosts + "/${hostname}/meta.nix");
      getHosts = builtins.filter (
        hostname:
        let
          hostPath = ./hosts + "/${hostname}";
          hasBase =
            builtins.pathExists (hostPath + "/imports.nix") && builtins.pathExists (hostPath + "/meta.nix");
        in
        (builtins.readDir ./hosts).${hostname} == "directory" && hasBase
      ) (builtins.attrNames (builtins.readDir ./hosts));
      getUsers =
        hostPath:
        let
          usersDir = hostPath + "/users";
        in
        if builtins.pathExists usersDir then
          builtins.filter (
            username:
            let
              userPath = usersDir + "/${username}";
              hasBase = builtins.pathExists (userPath + "/imports.nix");
            in
            (builtins.readDir usersDir).${username} == "directory" && hasBase
          ) (builtins.attrNames (builtins.readDir usersDir))
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
          hmModule =
            if isStable then
              home-manager-stable.nixosModules.home-manager
            else
              home-manager.nixosModules.home-manager;
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
              (hostPath + "/imports.nix")
              hmModule
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
                  config.allowUnfree = true;
                };
              }
            ]
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
              (userPath + "/imports.nix")
              {
                home = {
                  inherit username;
                  homeDirectory = "/home/${username}";
                  stateVersion = meta.stateVersion;
                };
                programs.home-manager.enable = true;
              }
            ]
            ++ lib.optionals (builtins.pathExists (userPath + "/options.nix")) [ (userPath + "/options.nix") ];
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
      nixosConfigurations = nixpkgs.lib.listToAttrs (map mkHost getHosts);
      homeConfigurations = nixpkgs.lib.listToAttrs (map mkHome getHomes);
      devShells = forAllSystems devShells;
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
