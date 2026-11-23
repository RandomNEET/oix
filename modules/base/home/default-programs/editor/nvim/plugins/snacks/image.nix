{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.defaultPrograms.editor.nvim.enable ({
    programs.nixvim = rec {
      plugins.snacks.settings.image = {
        enabled = builtins.elem config.defaultPrograms.terminal.default [ "kitty" ];
      };
      extraPackages = lib.mkIf plugins.snacks.settings.image.enabled (
        with pkgs;
        [
          ghostscript
          mermaid-cli
        ]
      );
    };
  });
}
