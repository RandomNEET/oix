{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.oix.desktop = {
    enable = mkOption {
      type = types.bool;
      default = true;
      readOnly = true;
      description = "Global indicator flag set automatically when a desktop environment or Wayland compositor is imported.";
    };
  };
}
