{ lib, pkgs, ... }:
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
                  description = "The system identifier for the display output.";
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
          description = "Hardware specifications for connected monitors.";
        };
        ddcutil = {
          enable = mkEnableOption "Enable ddcutil for display brightness and settings control";
          users = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "List of users to be added to the 'i2c' group.";
          };
        };
      };
    };
  };
}
