{
  imports = [
    ../../modules/base

    ../../modules/base/optionals/audio
    ../../modules/base/optionals/bluetooth
    ../../modules/base/optionals/games
    ../../modules/base/optionals/impermanence
    ../../modules/base/optionals/power
    ../../modules/base/optionals/secure-boot

    ../../modules/virtualisation/libvirtd

    ../../modules/services/dae
    ../../modules/services/flatpak
    ../../modules/services/fstrim
    ../../modules/services/greetd
    ../../modules/services/kmonad

    ../../modules/programs/firejail

    ../../modules/scripts/gen-diff.nix
    ../../modules/scripts/oix-init.nix
    ../../modules/scripts/snapper-list.nix
  ];
}
