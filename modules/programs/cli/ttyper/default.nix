{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      home = {
        packages = with pkgs; [ ttyper ];
        file = {
          ".config/ttyper/config.toml".source = ./config.toml;
          ".config/ttyper/language/symbol".source = ./symbol;
        };
      };
    })
  ];
}
