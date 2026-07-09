{ lib, ... }:
let
  inherit (lib) mkOption mkEnableOption types;
in
{
  options = {
    base = {
      impermanence = {
        enable = mkEnableOption "Whether to enable impermanence.";
        persistDir = mkOption {
          type = types.str;
          default = "/persist";
          description = "The path to your persistent storage location.";
        };
      };
    };
  };
}
