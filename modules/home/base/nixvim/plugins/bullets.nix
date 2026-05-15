{ lib, meta, ... }:
{
  programs.nixvim = {
    plugins.bullets = {
      enable = true;
    };
  }
  // lib.optionalAttrs (meta.channel == "unstable") {
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
}
