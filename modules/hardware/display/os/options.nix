{ config, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.oix.hardware.display = {
    info = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            output = mkOption {
              type = types.str;
              description = "Connector name of the display output (for example, `DP-1` or `HDMI-A-1`).";
            };
            width = mkOption {
              type = types.ints.unsigned;
              description = "Native horizontal resolution of the display in pixels.";
            };
            height = mkOption {
              type = types.ints.unsigned;
              description = "Native vertical resolution of the display in pixels.";
            };
            orientation = mkOption {
              type = types.enum [
                "landscape"
                "portrait"
              ];
              description = "Physical orientation of the monitor panel.";
            };
          };
        }
      );
      default = [ ];
      description = ''
        List of connected monitor specifications used by compositors, wallpaper scripts, and full-screen applications.
        The first monitor with `"landscape"` orientation is selected as the primary display.
      '';
    };
    ddcutil = {
      enable = mkOption {
        type = types.bool;
        default = config.oix.hardware.display.ddcutil.users != [ ];
        defaultText = lib.literalExpression "config.oix.hardware.display.ddcutil.users != [ ]";
        readOnly = true;
        description = "Global indicator flag set automatically when `oix.hardware.display.ddcutil.users` is non-empty.";
      };
      users = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          List of users to add to the `i2c` group for `/dev/i2c-*` access.
          When non-empty, `ddcutil` and kernel I2C device support are automatically enabled.
        '';
      };
    };
  };
}
