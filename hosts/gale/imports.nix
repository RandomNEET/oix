{
  imports = [
    ../../modules/optional/os/programs/firejail

    ../../modules/optional/os/services/dae
    ../../modules/optional/os/services/flatpak
    ../../modules/optional/os/services/fstrim
    ../../modules/optional/os/services/kmonad

    ../../modules/optional/os/scripts/gen-diff.nix
    ../../modules/optional/os/scripts/oix-init.nix
    ../../modules/optional/os/scripts/snapper-list.nix

    ../../modules/optional/os/virtualisation/libvirtd
    ../../modules/optional/os/virtualisation/podman
  ];
}
