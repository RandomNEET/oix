{ mylib, meta, ... }:
{
  imports = [
    (mylib.util.mkModule ./. meta)
    ../shared/security
    ../shared/ly
    ../shared/xdg
    ../shared/flatpak
    ../shared/fonts
    ../shared/themes
    ../shared/fcitx5
    ../shared/packages
  ];
}
