{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./options.nix ];
  config = lib.mkIf config.base.display.ddcutil.enable {
    environment.systemPackages = [ pkgs.ddcutil ];
    hardware.i2c.enable = true;
    users.users = lib.genAttrs config.base.display.ddcutil.users (name: {
      extraGroups = [ "i2c" ];
    });
  };
}
