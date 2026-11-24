{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options = {
    base = {
      secureBoot = {
        enable = mkEnableOption "UEFI Secure Boot support via Lanzaboote";
      };
    };
  };
}
