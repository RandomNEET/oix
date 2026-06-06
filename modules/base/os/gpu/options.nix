{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    base = {
      gpu = mkOption {
        type = types.enum [
          "amd"
          "intel-integrated"
          "nvidia"
          "none"
        ];
        default = "none";
        description = "The primary GPU architecture of the machine.";
      };
    };
  };
}
