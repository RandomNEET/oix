{ mylib, meta, ... }:
{
  imports = [
    (mylib.util.mkModule ./. meta)
    ../shared/security
    ../shared/ly
    ../shared/xdg
    ../shared/flatpak
    ../shared/udisks
    ../shared/fonts
    ../shared/themes
    ../shared/wallpaper
    ../shared/fcitx5
    ../shared/noctalia
    ../shared/packages
  ];
}
