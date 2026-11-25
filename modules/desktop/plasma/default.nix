{ mylib, meta, ... }:
{
  imports = [
    (mylib.util.mkModule ./. meta)
    ../shared/base
    ../shared/security
    ../shared/xdg
    ../shared/fcitx5
    ../shared/packages
    ../shared/flatpak
  ];
}
