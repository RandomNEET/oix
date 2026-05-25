{
  imports = [
    ../../modules/os/services/fstrim
    ../../modules/os/services/xray

    ../../modules/os/scripts/gen-diff.nix
    ../../modules/os/scripts/oix-init.nix

    ../../modules/os/virtualisation/docker
    ../../modules/os/virtualisation/libvirtd
  ];
}
