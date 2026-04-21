{ lib, meta, ... }:
{
  programs.nixvim = {
    plugins.mini-icons = {
      enable = true;
      mockDevIcons = true;
    }
    // lib.optionalAttrs (meta.channel == "unstable") {
      lazyLoad = {
        enable = true;
        settings = {
          event = "DeferredUIEnter";
        };
      };
    };
  };
}
