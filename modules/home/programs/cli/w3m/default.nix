{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optionalAttrs;
  hasDesktop = osConfig.desktop.enable;
in
{
  programs.w3m = {
    enable = true;
    settings = {
      confirm_qq = 0;
      vi_prec_num = 1;
      smartcase_search = 1;
    }
    // optionalAttrs hasDesktop {
      display_image = 1;
      auto_image = 1;
      extbrowser = config.defaultPrograms.browser;
    };
  }
  // optionalAttrs hasDesktop {
    w3mImg2Sixel = "img2sixel";
    extraPackages = with pkgs; [ libsixel ];
  }
  // optionalAttrs (!hasDesktop) {
    package = pkgs.w3m-nographics;
  };
}
