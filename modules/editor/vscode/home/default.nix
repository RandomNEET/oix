{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  profiles = import ./profiles { inherit config lib pkgs; };
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhs;
    inherit profiles;
  };

  home.file.".config/Code/User/vscode-neovim.lua".source = ./vscode-neovim.lua;
}
// lib.optionalAttrs (osConfig.oix.appearance.themes.enable or false) {
  stylix.targets.vscode = {
    enable = true;
    profileNames = builtins.attrNames profiles;
  };
}
