{
  inputs,
  config,
  lib,
  opts,
  ...
}:
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
  services.flatpak = {
    enable = true;
    packages = opts.flatpak.packages.system;
    update = {
      onActivation = false;
    };
  };
  home-manager.sharedModules = [
    (_: {
      imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
      services.flatpak.packages = opts.flatpak.packages.user;
    })
  ];
  systemd.services.flatpak-managed-install.serviceConfig = lib.mkIf config.services.greetd.enable {
    Type = lib.mkForce "idle";
  };
}
