{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options = {
    base = {
      power = {
        enable = mkEnableOption "power management services via power-profiles-daemon and UPower";
      };
    };
  };
}
