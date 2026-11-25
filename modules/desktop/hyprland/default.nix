{ mylib, meta, ... }:
{
  imports = [
    (mylib.util.mkModule ./. meta)
    ../shared/base
    ../shared/security
    ../shared/xdg
    ../shared/noctalia
    ../shared/fcitx5
    ../shared/udisks
    ../shared/packages
    ../shared/flatpak
    ../shared/wallpaper
  ];
}
