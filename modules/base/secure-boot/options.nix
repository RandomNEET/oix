{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options = {
    base = {
      secure-boot = {
        enable = mkEnableOption "Whether to enable UEFI Secure Boot support.";
      };
    };
  };
}
