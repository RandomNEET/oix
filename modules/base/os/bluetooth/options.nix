{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options = {
    base = {
      bluetooth = {
        enable = mkEnableOption "support for Bluetooth";
      };
    };
  };
}
