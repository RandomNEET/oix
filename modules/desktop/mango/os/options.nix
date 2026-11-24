{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.oix.desktop.mango = {
    enable = mkOption {
      type = types.bool;
      default = true;
      readOnly = true;
      description = "Global indicator flag set automatically when `modules/desktop/mango` is imported.";
    };
  };
}
