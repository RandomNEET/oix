{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optionalAttrs;
  desktopEnabled = osConfig.oix.desktop.enable or false;
in
{
  config = {
    programs.w3m = {
      enable = true;
      settings = {
        confirm_qq = 0;
        vi_prec_num = 1;
        smartcase_search = 1;
      }
      // optionalAttrs desktopEnabled {
        display_image = 1;
        auto_image = 1;
      }
      // optionalAttrs (desktopEnabled && config.oix.defaults.browser != null) {
        extbrowser = config.oix.defaults.browser;
      };
    }
    // optionalAttrs desktopEnabled {
      w3mImg2Sixel = "img2sixel";
      extraPackages = with pkgs; [ libsixel ];
    }
    // optionalAttrs (!desktopEnabled) {
      package = pkgs.w3m-nographics;
    };
  }
  // {
    oix.defaults.browser = lib.mkDefault "w3m";
  };
}
