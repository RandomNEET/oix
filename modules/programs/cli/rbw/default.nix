{
  lib,
  pkgs,
  opts,
  ...
}:
let
  hasDesktop = opts ? desktop;
in
{
  home-manager.sharedModules = [
    {
      programs.rbw = {
        enable = true;
        settings = {
          base_url = opts.rbw.settings.base_url or null;
          email = opts.rbw.settings.email or "";
          identity_url = opts.rbw.settings.identity_url or null;
          lock_timeout = opts.rbw.settings.lock_timeout or 3600;
          pinentry = if hasDesktop then pkgs.pinentry-qt else pkgs.pinentry-curses;
        };
      };
      home.packages = [
        pkgs.pinentry-all
      ]
      ++ lib.optionals hasDesktop [
        pkgs.rofi-rbw
        pkgs.wtype
      ];
    }
  ];
}
