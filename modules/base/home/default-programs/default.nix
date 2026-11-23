{
  config,
  lib,
  mylib,
  ...
}:
let
  inherit (lib) optionalAttrs;
  cfg = config.defaultPrograms;
in
{
  imports = mylib.util.scanPaths ./. { };
  config = {
    home.sessionVariables =
      (optionalAttrs (cfg.terminal.default != null) {
        TERMINAL = cfg.terminal.default;
      })
      // (optionalAttrs (cfg.browser.default != null) {
        BROWSER = cfg.browser.default;
      });
  };
}
