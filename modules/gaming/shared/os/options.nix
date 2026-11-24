{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.oix.gaming = {
    enable = mkOption {
      type = types.bool;
      default = true;
      readOnly = true;
      description = "Global indicator flag set automatically when any gaming module is imported.";
    };
  };
}
