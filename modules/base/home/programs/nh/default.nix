{ lib, meta, ... }:
let
  isHm = meta.platform == "home-manager";
in
rec {
  programs.nh = {
    enable = isHm;
    osFlake = meta.flake;
    homeFlake = meta.flake;
    clean = {
      enable = isHm;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 3d --no-gcroots";
    };
  };
  systemd.user.services = {
    nh-clean = lib.mkIf programs.nh.clean.enable {
      Service.Environment = [
        "PATH=/nix/var/nix/profiles/default/bin"
      ];
    };
  };
}
