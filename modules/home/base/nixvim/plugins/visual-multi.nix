{ lib, meta, ... }:
{
  programs.nixvim = {
    plugins.visual-multi = {
      enable = true;
      settings = {
        default_mappings = 1;
        mouse_mappings = 1;
        set_statusline = 2;
        show_warnings = 1;
        silent_exit = 0;
      };
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
