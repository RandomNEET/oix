{
  imports = [
    ../../modules/services/fstrim
    ../../modules/services/xray

    ../../modules/scripts/gen-diff.nix
    ../../modules/scripts/oix-init.nix

    ../../modules/virtualisation/docker
    ../../modules/virtualisation/libvirtd
  ];
}
