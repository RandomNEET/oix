{ pkgs, meta, ... }:
{
  imports = [
    ../../../../modules/core/home/options.nix
    ../../../../modules/core/home/defaults.nix
  ];

  oix = {
    defaults = {
      editor = "nvim";
    };
  };
  programs = {
    home-manager.enable = true;
  };
  home = {
    packages = with pkgs; [ deepseek-harness ];
    preferXdgDirectories = true;
    username = "howl";
    homeDirectory = "/home/howl";
    stateVersion = meta.stateVersion;
  };
  xdg = {
    enable = true;
  };
}
