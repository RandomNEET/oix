{
  config,
  lib,
  pkgs,
  ...
}:
let
  start-mango = lib.getExe (pkgs.callPackage ../../shared/scripts/start-mango.nix { inherit pkgs; });
in
{
  imports = [ ./options.nix ];

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    configPackages = [ pkgs.xdg-desktop-portal-wlr ];
  };

  environment.etc = lib.optionalAttrs (config.oix.desktop.ly.enable or false) {
    "ly/sessions/wayland/mango.desktop".text = ''
      [Desktop Entry]
      Name=mango
      Exec=${start-mango}
      DesktopNames=mango;wlroots
    '';
  };
}
