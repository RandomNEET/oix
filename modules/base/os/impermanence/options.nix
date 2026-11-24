{ lib, ... }:
let
  inherit (lib) mkOption mkEnableOption types;
in
{
  options = {
    base = {
      impermanence = {
        enable = mkEnableOption "impermanence, persistent state management for systems with ephemeral root storage";
        persistDir = mkOption {
          type = types.str;
          default = "/persist";
          description = "Full path to the persistent storage location where state files and directories are stored.";
        };
      };
    };
  };
}
