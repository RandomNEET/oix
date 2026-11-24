{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options = {
    base = {
      gaming = {
        enable = mkEnableOption "the gaming environment, including Steam, Gamescope, GameMode, and controller support";
      };
    };
  };
}
