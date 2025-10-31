{
  description = "howl's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nixvim = {
      url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      # url = "github:nix-community/nixvim/nixos-25.05";
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
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
  };
  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      hosts = builtins.filter (name: builtins.pathExists ./hosts/${name}/options.nix) (
        builtins.attrNames (builtins.readDir ./hosts)
      );
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (
          name:
          let
            opts = import ./hosts/${name}/options.nix;
          in
          {
            name = opts.hostname;
            value = nixpkgs.lib.nixosSystem {
              system = opts.system;
              specialArgs = {
                inherit inputs opts;
              };
              modules = [
                ./hosts/${name}
                home-manager.nixosModules.home-manager
                {
                  home-manager.extraSpecialArgs = {
                    inherit opts;
                  };
                }
                {
                  nixpkgs.overlays = [
                    (final: prev: import ./pkgs { pkgs = final; })
                  ];
                }
              ];
            };
          }
        ) hosts
      );
    };
}
