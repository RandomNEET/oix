{ pkgs, ... }:
{
  home-manager.sharedModules = [
    {
      home = {
        packages = with pkgs; [ glow ];
        file.".config/glow/glow.yml".source = ./glow.yml;
      };
    }
  ];
}
