{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options = {
    base = {
      secureBoot = {
        enable = mkEnableOption "Whether to enable UEFI Secure Boot support.";
      };
    };
  };
}
