{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options = {
    base = {
      power = {
        enable = mkEnableOption "Whether to enable power management services.";
      };
    };
  };
}
