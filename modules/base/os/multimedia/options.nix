{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options = {
    base = {
      multimedia = {
        enable = mkEnableOption "PipeWire multimedia framework with ALSA, PulseAudio, and WirePlumber support";
      };
    };
  };
}
