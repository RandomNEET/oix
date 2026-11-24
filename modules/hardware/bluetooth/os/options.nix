{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.oix.hardware.bluetooth = {
    enable = mkOption {
      type = types.bool;
      default = true;
      readOnly = true;
      description = "Global indicator flag set automatically when `modules/hardware/bluetooth` is imported.";
    };
  };
}
