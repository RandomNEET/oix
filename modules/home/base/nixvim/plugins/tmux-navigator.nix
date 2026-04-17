{ lib, meta, ... }:
{
  programs.nixvim = {
    plugins.tmux-navigator = {
      enable = true;
    };
  }
  // lib.optionalAttrs (meta.channel == "unstable") {
    lazyLoad = {
      enable = true;
      settings = {
        event = "DeferredUIEnter";
      };
    };
  };
}
