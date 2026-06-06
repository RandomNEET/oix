{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options = {
    base = {
      gaming = {
        enable = mkEnableOption "Whether to enable the gaming environment.";
      };
    };
  };
}
