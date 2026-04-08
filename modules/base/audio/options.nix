{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options = {
    base = {
      audio = {
        enable = mkEnableOption "Whether to enable PipeWire-based audio support with ALSA and PulseAudio compatibility.";
      };
    };
  };
}
