{
  config,
  lib,
  pkgs,
  ...
}:
let
  users = config.oix.hardware.display.ddcutil.users;
in
{
  imports = [ ./options.nix ];

  config = lib.mkIf config.oix.hardware.display.ddcutil.enable {
    environment.systemPackages = [ pkgs.ddcutil ];
    hardware.i2c.enable = true;
    users.users = lib.genAttrs users (_name: {
      extraGroups = [ "i2c" ];
    });
  };
}
