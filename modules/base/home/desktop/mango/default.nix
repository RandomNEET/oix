{
  osConfig,
  config,
  lib,
  pkgs,
  mylib,
  ...
}:
let
  inherit (lib) getExe;
  launcher = getExe (
    import ../shared/scripts/launcher.nix {
      inherit
        osConfig
        config
        lib
        pkgs
        ;
    }
  );
  clip-manager = getExe (import ../shared/scripts/clip-manager.nix { inherit pkgs; });
  file-manager = getExe (import ../shared/scripts/file-manager.nix { inherit config pkgs; });
  screenshot = getExe (import ../shared/scripts/screenshot.nix { inherit config pkgs; });
  autoclicker = getExe (pkgs.callPackage ../shared/scripts/autoclicker.nix { });
  colors = config.lib.stylix.colors;
  primaryColor = mylib.theme.getThemePrimaryColor colors config.stylix.base16Scheme;
in
{
  imports = [
    ../shared/fonts
    ../shared/themes
    ../shared/xdg
    ../shared/programs/fcitx5
    ../shared/programs/gowall
    ../shared/programs/noctalia-shell
    ../shared/programs/rofi
    ../shared/programs/satty
    ../shared/services/cliphist
    ../shared/services/udiskie
    ../shared/services/wayland-pipewire-idle-inhibit
  ];

  config = lib.mkIf osConfig.desktop.mango.enable {
    wayland.windowManager.mango =
      let
        binds = import ./binds.nix {
          inherit
            osConfig
            config
            lib
            pkgs
            launcher
            clip-manager
            file-manager
            screenshot
            autoclicker
            ;
        };
        autostart = import ./autostart.nix { inherit osConfig config lib; };
      in
      {
        enable = true;
        # package = pkgs.mangowc;
        systemd = {
          enable = true;
          xdgAutostart = true;
        };
        settings = {
          inherit (binds)
            bind
            mousebind
            axisbind
            keymode
            ;
          layerrule = (import ./rules.nix).layerrule;
          windowrule = (import ./rules.nix).windowrule;
          env = import ./env.nix;
          exec-once = autostart.exec-once;
        }
        // import ./animations.nix
        // import ./misc.nix
        // lib.optionalAttrs osConfig.desktop.themes.enable {
          rootcolor = "0x${colors.base00}ff";
          bordercolor = "0x${colors.base02}ff";
          dropcolor = "0x${colors.base01}55";
          splitcolor = "0x${colors.base0D}ff";
          focuscolor = "0x${primaryColor}ff";
          urgentcolor = "0x${colors.base08}ff";
        };
      };

    services.lxqt-policykit-agent.enable = true;
    systemd.user = {
      services.lxqt-policykit-agent = {
        Unit = {
          After = [
            "home.mount"
            "basic.target"
            "-.mount"
            "app.slice"
            "graphical-session.target"
          ];
        };
      };
    };

    home.packages = with pkgs; [
      libnotify
      wl-clipboard
      hyprpicker
      wlrctl # mouse control
      yad # keybinds script
      # Screenshot (satty in imports)
      grim
      slurp
      wayfreeze
      tesseract
    ];
  };
}
