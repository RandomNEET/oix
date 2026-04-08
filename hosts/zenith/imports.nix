{
  imports = [
    ../../modules/programs/firejail

    ../../modules/services/dae
    ../../modules/services/flatpak
    ../../modules/services/fstrim
    ../../modules/services/greetd

    ../../modules/scripts/gen-diff.nix
    ../../modules/scripts/oix-init.nix
    ../../modules/scripts/snapper-list.nix

    ../../modules/virtualisation/libvirtd
  ];
}
