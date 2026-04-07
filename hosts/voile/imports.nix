{
  imports = [
    ../../modules/base

    ../../modules/virtualisation/docker
    ../../modules/virtualisation/libvirtd

    ../../modules/services/cron
    ../../modules/services/fstrim
    ../../modules/services/xray

    ../../modules/scripts/gen-diff.nix
    ../../modules/scripts/oix-init.nix
  ];
}
