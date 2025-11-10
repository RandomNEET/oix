{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      home = {
        packages = with pkgs; [ glow ];
        file.".config/glow/glow.yml".source = ./glow.yml;
      };
    })
  ];
}
