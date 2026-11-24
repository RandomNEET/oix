{ lib, ... }:
let
  inherit (lib) mkOption mkEnableOption types;
in
{
  options = {
    base = {
      display = {
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
          enable = mkEnableOption "ddcutil and I2C device support for querying and changing monitor settings via DDC/CI";
          users = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "List of users to add to the `i2c` group for access to `/dev/i2c-*` devices.";
          };
        };
      };
    };
  };
}
