{ inputs, opts, ... }:
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
  services.flatpak = {
    enable = true;
    update = {
      onActivation = false;
    };
    packages = opts.packages.flatpak.system or [ ];
  };
  home-manager.sharedModules = [
    (_: {
      imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
      services.flatpak.packages = opts.packages.flatpak.home or [ ];
    })
  ];
}
