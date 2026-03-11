{ inputs, opts, ... }:
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
  services.flatpak = {
    enable = true;
    update = {
      onActivation = false;
    };
    packages = opts.flatpak.packages.system or [ ];
  };
  home-manager.sharedModules = [
    {
      imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
      services.flatpak.packages = opts.flatpak.packages.home or [ ];
    }
  ];
}
