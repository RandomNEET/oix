{ config, lib, ... }:
{
  config = lib.mkIf config.defaultPrograms.editor.nvim.enable ({
    programs.nixvim = {
      plugins.numbertoggle = {
        enable = true;
        lazyLoad = {
          enable = true;
          settings = {
            event = [
              "BufReadPost"
              "BufNewFile"
              "BufWritePre"
            ];
          };
        };
      };
    };
  });
}
