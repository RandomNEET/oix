{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.oix.gaming.gamescope = {
    enable = mkOption {
      type = types.bool;
      default = true;
      readOnly = true;
      description = "Global indicator flag set automatically when `modules/gaming/gamescope` is imported.";
    };
  };
}
