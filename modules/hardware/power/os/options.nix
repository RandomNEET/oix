{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.oix.hardware.power = {
    hibernate = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to support system hibernation (suspend-to-disk).
        When enabled, `security.protectKernelImage` is disabled so the kernel can resume from swap.
      '';
    };
  };
}
