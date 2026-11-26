{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.nixvim = rec {
    plugins.snacks.settings.image = {
      enabled = builtins.elem config.oix.defaults.terminal [ "kitty" ];
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
