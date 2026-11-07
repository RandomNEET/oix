{
  osConfig,
  config,
  lib,
  pkgs,
  mylib,
  ...
}:
let
  appearance = import ./appearance.nix { inherit osConfig config mylib; };
in
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
        mylib
        ;
    };
    keyBindings = import ./binds.nix { inherit config lib; };
    quickmarks = import ./quickmarks.nix;
    searchEngines = import ./search.nix;
    perDomainSettings = import ./domains.nix;
    greasemonkey = import ./greasemonkey.nix { inherit pkgs; };
    extraConfig = ''
      c.tabs.padding = {"top": 7, "bottom": 7, "left": 12, "right": 12}
      c.statusbar.padding = {"top": 5, "bottom": 5, "left": 10, "right": 10}
      config.source(${builtins.toJSON "${config.xdg.configHome}/qutebrowser/appearance.py"})
    '';
  };
  # Reload colors without changing runtime layout
  xdg.configFile."qutebrowser/appearance.py".text = ''
    import json
    for name, value in json.loads(${builtins.toJSON (builtins.toJSON appearance.settings)}).items():
        config.set(name, value)
  '';
  imports = [
    ./startpage
    ./userscripts
  ];
}
