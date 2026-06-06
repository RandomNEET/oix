{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options = {
    base = {
      multimedia = {
        enable = mkEnableOption "Whether to enable PipeWire-based multimedia support.";
      };
    };
  };
}
