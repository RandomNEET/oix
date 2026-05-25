{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options = {
    base = {
      impermanence = {
        enable = mkEnableOption "Whether to enable ephemeral storage persistence.";
      };
    };
  };
}
