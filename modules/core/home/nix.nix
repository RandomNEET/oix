{
  lib,
  pkgs,
  meta,
  ...
}:
{
  nix = lib.mkIf (meta.platform == "home-manager") {
    settings = {
      extra-substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store?priority=30"
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      extra-experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    registry = {
      oix = {
        to = {
          type = "path";
          path = meta.flake;
        };
      };
    };
    package = pkgs.lixPackageSets.stable.lix;
  };
}
