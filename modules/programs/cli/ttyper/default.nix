{
  lib,
  pkgs,
  opts,
  ...
}:
let
  base = ''
    default_language = "english1000"
  '';
  theme = lib.optionalString ((opts.theme or "") != "") (builtins.readFile ./${opts.theme}.toml);
in
{
  home-manager.sharedModules = [
    {
      home = {
        packages = with pkgs; [ ttyper ];
        file = {
          ".config/ttyper/config.toml".text = base + theme;
          ".config/ttyper/language/symbol".source = ./symbol;
        };
      };
    }
  ];
}
