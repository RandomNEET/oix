{ config, lib, ... }:
let
  inherit (lib) optionalAttrs;
  cfg = config.defaultPrograms;
in
{
  imports = [ ./options.nix ];
  config = {
    home.sessionVariables =
      (optionalAttrs (cfg.terminal != null) {
        TERMINAL = cfg.terminal;
      })
      // (optionalAttrs (cfg.browser != null) {
        BROWSER = cfg.browser;
      });
  };
}
