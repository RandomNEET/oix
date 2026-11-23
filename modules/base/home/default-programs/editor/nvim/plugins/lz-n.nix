{ config, lib, ... }:
{
  config = lib.mkIf config.defaultPrograms.editor.nvim.enable ({
    programs.nixvim = {
      plugins.lz-n = {
        enable = true;
      };
    };
  });
}
