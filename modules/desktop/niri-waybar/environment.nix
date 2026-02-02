{
  osConfig,
  config,
  lib,
  ...
}:
{
  ELECTRON_OZONE_PLATFORM = "wayland";
  QT_QPA_PLATFORM = "wayland";
  QT_QPA_PLATFORMTHEME = "qt6ct";
}
// lib.optionalAttrs osConfig.programs.firejail.enable {
  PATH = "${lib.concatStringsSep ":" [
    "${config.home.homeDirectory}/.local/bin"
    "/run/wrappers/bin"
    "${config.home.homeDirectory}/.local/share/flatpak/exports/bin"
    "/var/lib/flatpak/exports/bin"
    "${config.home.homeDirectory}/.nix-profile/bin"
    "/nix/profile/bin"
    "${config.home.homeDirectory}/.local/state/nix/profile/bin"
    "/etc/profiles/per-user/${config.home.username}/bin"
    "/nix/var/nix/profiles/default/bin"
    "/run/current-system/sw/bin"
  ]}";
}
