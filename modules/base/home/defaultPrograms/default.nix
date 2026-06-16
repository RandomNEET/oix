{ config, lib, ... }:
let
  inherit (lib) optionalAttrs;
  cfg = config.defaultPrograms;
in
{
  imports = [ ./options.nix ];
  config = {
    home.sessionVariables =
      (optionalAttrs (cfg.terminal != "none") {
        TERMINAL = cfg.terminal;
      })
      // (optionalAttrs (cfg.browser != "none") {
        BROWSER = cfg.browser;
      });
  };
}
