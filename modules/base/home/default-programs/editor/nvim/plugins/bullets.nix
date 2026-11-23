{ config, lib, ... }:
{
  config = lib.mkIf config.defaultPrograms.editor.nvim.enable ({
    programs.nixvim = {
      plugins.bullets = {
        enable = true;
        lazyLoad = {
          enable = true;
          settings = {
            ft = [
              "markdown"
              "text"
              "gitcommit"
              "scratch"
            ];
          };
        };
      };
    };
  });
}
