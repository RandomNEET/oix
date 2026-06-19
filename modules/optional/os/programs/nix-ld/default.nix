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
    libraries = with pkgs; [ ] ++ optional (config.base.gpu != "none") vulkan-loader;
  };
}
