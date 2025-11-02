{ lib, opts, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.swaylock = {
        enable = true;
        settings = {
          scaling = "fill";
          color = "1e1e2e";
          font = "JetBrains Mono Nerd Font";
          font-size = 24;
          indicator-radius = 60;
          indicator-thickness = 10;
          inside-color = "1e1e2e";
          line-color = "cba6f7";
          ring-color = "89b4fa";
          text-color = "cdd6f4";
          text-wrong-color = "f38ba8";
          bs-hl-color = "f38ba8";
          key-hl-color = "a6e3a1";
          indicator-idle-visible = true;
          show-failed-attempts = true;
        }
        // lib.optionalAttrs ((opts.swaylock.image or "") != "") {
          image = opts.swaylock.image;
        };
      };
    })
  ];
}
