{ config, lib, ... }:
{
  programs.nixvim = lib.mkIf config.programs.tmux.enable {
    plugins.tmux-navigator = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = {
          event = "DeferredUIEnter";
        };
      };
    };
  };
}
