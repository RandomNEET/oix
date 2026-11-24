{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.oix.storage.impermanence = {
    enable = mkOption {
      type = types.bool;
      default = true;
      readOnly = true;
      description = "Global indicator flag set automatically when `modules/storage/impermanence` is imported.";
    };
    persistDir = mkOption {
      type = types.str;
      default = "/persist";
      description = "Full path to the persistent storage location where state files and directories are stored.";
    };
  };
}
