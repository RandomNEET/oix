{
  imports = [
    ../../modules/optional/os/services/cron
    ../../modules/optional/os/services/fstrim
    ../../modules/optional/os/services/xray

    ../../modules/optional/os/scripts/gen-diff.nix
    ../../modules/optional/os/scripts/nix-daemon-proxy.nix
    ../../modules/optional/os/scripts/oix-init.nix

    ../../modules/optional/os/virtualisation/docker
    ../../modules/optional/os/virtualisation/libvirtd
  ];
}
