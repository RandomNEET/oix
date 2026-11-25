{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.oix.hardware.display;
in
{
  imports = [ ./options.nix ];

  config = lib.mkIf cfg.ddcutil.enable {
    environment.systemPackages = [ pkgs.ddcutil ];
    hardware.i2c.enable = true;
    users.users = lib.genAttrs cfg.ddcutil.users (_name: {
      extraGroups = [ "i2c" ];
    });
  };
}
