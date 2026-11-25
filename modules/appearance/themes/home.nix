{
  inputs,
  osConfig,
  lib,
  pkgs,
  meta,
  ...
}:
let
  inherit (lib) mkForce mkIf mkMerge;
  themesList = osConfig.oix.appearance.themes.list or [ ];
  themesEnabled = osConfig.oix.appearance.themes.enable or false;
  fontsEnabled = osConfig.oix.appearance.fonts.enable or false;
  fontsCfg = osConfig.oix.appearance.fonts or { };
  mkStylixFont = list: mkIf (list != [ ]) { inherit (builtins.head list) package name; };
  desktopEnabled = osConfig.oix.desktop.enable or false;
  themeSwitcherEnabled = themesEnabled && builtins.length themesList > 1;
in
{
  imports = lib.optionals (meta.platform == "home-manager") [
    (
      if (meta.channel == "unstable") then
        inputs.stylix.homeModules.stylix
      else
        inputs.stylix-stable.homeModules.stylix
    )
  ];

  config = mkMerge [
    (mkIf themesEnabled {
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/${builtins.head themesList}.yaml";
        polarity = osConfig.oix.appearance.themes.polarity or "either";
        autoEnable = false;
      };
    })

    (mkIf (themesEnabled && fontsEnabled) {
      stylix = {
        targets = {
          font-packages.enable = true;
          fontconfig.enable = true;
        };
        fonts = {
          monospace = mkStylixFont (fontsCfg.monospace or [ ]);
          sansSerif = mkStylixFont (fontsCfg.sansSerif or [ ]);
          serif = mkStylixFont (fontsCfg.serif or [ ]);
          emoji = mkStylixFont (fontsCfg.emoji or [ ]);
        };
      };
    })

    (mkIf (themesEnabled && desktopEnabled) {
      stylix = {
        targets = {
          gtk = {
            enable = true;
            flatpakSupport.enable = true;
          };
          qt.enable = true;
        };
        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 24;
        };
        icons = {
          enable = true;
          package = pkgs.papirus-icon-theme;
          dark = "Papirus-Dark";
          light = "Papirus-Light";
        };
      };
    })

    (mkIf themeSwitcherEnabled {
      specialisation = builtins.listToAttrs (
        map (theme: {
          name = theme;
          value = {
            configuration = {
              stylix.base16Scheme = mkForce "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
            };
          };
        }) (builtins.tail themesList)
      );
      home.activation.saveHmBasePath = ''
        LINK_PATH="''${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/home-manager-base"

        if [[ ! "$0" =~ "specialisation" ]]; then
          mkdir -p "$(dirname "$LINK_PATH")"
          REAL_SELF=$(readlink -f "$0")
          BASE_GEN=''${REAL_SELF%/activate}

          if [ -d "$BASE_GEN/specialisation" ]; then
            ln -sfn "$BASE_GEN" "$LINK_PATH"
          fi
        fi
      '';
    })

    (mkIf (!themeSwitcherEnabled) {
      home.activation.removeHmBasePath = ''
        LINK_PATH="''${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/home-manager-base"

        if [[ ! "$0" =~ "specialisation" ]]; then
          if [ -L "$LINK_PATH" ] || [ -e "$LINK_PATH" ]; then
            rm -f "$LINK_PATH"
          fi
        fi
      '';
    })
  ];
}
