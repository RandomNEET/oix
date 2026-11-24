{ lib, meta, ... }:
{
  config = lib.mkIf (meta.platform == "home-manager") {
    programs.nh = {
      enable = true;
      osFlake = meta.flake;
      homeFlake = meta.flake;
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep 5 --keep-since 3d --no-gcroots";
      };
    };
    systemd.user.services = {
      nh-clean = {
        Service.Environment = [
          "PATH=/nix/var/nix/profiles/default/bin"
        ];
      };
    };
  };
}
