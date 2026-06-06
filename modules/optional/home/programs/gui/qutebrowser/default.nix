{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.qutebrowser = {
    enable = true;
    loadAutoconfig = false;
    enableDefaultBindings = false;
    settings = import ./settings.nix {
      inherit
        osConfig
        config
        lib
        pkgs
        ;
    };
    keyBindings = import ./binds.nix { inherit config lib; };
    quickmarks = import ./quickmarks.nix;
    searchEngines = import ./search.nix;
    perDomainSettings = import ./domains.nix;
    greasemonkey = import ./greasemonkey.nix { inherit pkgs; };
  };
  imports = [ ./userscripts ];
}
