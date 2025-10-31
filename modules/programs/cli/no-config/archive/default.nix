{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ ];
  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [
        _7zz
        unrar
      ];
    })
  ];
}
