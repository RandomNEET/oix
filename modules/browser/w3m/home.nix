{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optionalAttrs;
  hasDesktop = osConfig.oix.desktop.enable or false;
in
{
  config = (
    {
      oix.defaults.browser = lib.mkDefault "w3m";
    }
    // {
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
        // optionalAttrs (hasDesktop && config.oix.defaults.browser != null) {
          extbrowser = config.oix.defaults.browser;
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
  );
}
