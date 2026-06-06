{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options = {
    base = {
      bluetooth = {
        enable = mkEnableOption "Whether to enable Bluetooth support with Blueman manager.";
      };
    };
  };
}
