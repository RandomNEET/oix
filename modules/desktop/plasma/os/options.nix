{ lib, ... }:
let
  inherit (lib) mkOption mkEnableOption types;
in
{
  options.oix.desktop.plasma = {
    enable = mkOption {
      type = types.bool;
      default = true;
      readOnly = true;
      description = "Global indicator flag set automatically when `modules/desktop/plasma` is imported.";
    };
    x11Support = mkEnableOption "X11 server support for Plasma";
  };
}
