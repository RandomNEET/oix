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
  config = lib.mkIf config.defaultPrograms.browser.w3m.enable ({
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
      }
      // optionalAttrs (hasDesktop && config.defaultPrograms.browser.default != null) {
        extbrowser = config.defaultPrograms.browser.default;
      };
    }
    // optionalAttrs hasDesktop {
      w3mImg2Sixel = "img2sixel";
      extraPackages = with pkgs; [ libsixel ];
    }
    // optionalAttrs (!hasDesktop) {
      package = pkgs.w3m-nographics;
    };
  });
}
