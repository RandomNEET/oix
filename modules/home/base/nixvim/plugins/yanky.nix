{ lib, meta, ... }:
{
  programs.nixvim = {
    plugins.yanky = {
      enable = true;
      settings = {
        highlight = {
          on_put = true;
          on_yank = true;
          timer = 100;
        };
      };
    }
    // lib.optionalAttrs (meta.channel == "unstable") {
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
}
