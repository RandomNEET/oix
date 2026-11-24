{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optional;
in
{
  programs.nix-ld = {
    enable = true;
    libraries =
      with pkgs;
      [ ] ++ optional ((config.oix.hardware.gpu or "none") != "none") vulkan-loader;
  };
}
