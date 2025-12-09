{
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      programs.rbw = {
        enable = true;
        settings = {
          base_url = opts.rbw.settings.base_url or null;
          email = opts.rbw.settings.email or "";
          identity_url = opts.rbw.settings.identity_url or null;
          lock_timeout = opts.rbw.settings.lock_timeout or 3600;
          pinentry = if (opts.rbw.rofi-rbw or false) then pkgs.pinentry-qt else pkgs.pinentry-curses;
        };
      };
      home.packages = [
        pkgs.pinentry-all
      ]
      ++ lib.optionals (opts.rbw.rofi-rbw or false) [ pkgs.rofi-rbw ];
    })
  ];
}
