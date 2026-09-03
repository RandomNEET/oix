{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.nixvim = rec {
    plugins.snacks.settings.image = {
      enabled = builtins.elem config.defaultPrograms.terminal [ "kitty" ];
    };
    extraPackages = lib.mkIf plugins.snacks.settings.image.enabled (
      with pkgs;
      [
        ghostscript
        mermaid-cli
      ]
    );
  };
}
