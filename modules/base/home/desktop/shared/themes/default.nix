{
  inputs,
  osConfig,
  lib,
  pkgs,
  meta,
  ...
}:
let
  themesEnabled = osConfig.desktop.themes.enable;
in
{
  imports = lib.optionals (themesEnabled && (meta.platform == "home-manager")) [
    (
      if (meta.channel == "unstable") then
        inputs.stylix.homeModules.stylix
      else
        inputs.stylix-stable.homeModules.stylix
    )
  ];

  config =
    if themesEnabled then
      let
        defaultTheme = builtins.head osConfig.desktop.themes.list;
        otherThemes = builtins.tail osConfig.desktop.themes.list;
      in
      {
        stylix = {
          enable = osConfig.desktop.themes.enable;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/${defaultTheme}.yaml";
          polarity = osConfig.desktop.themes.polarity;
          fonts = {
            monospace = builtins.head osConfig.desktop.fonts.monospace;
            sansSerif = builtins.head osConfig.desktop.fonts.sansSerif;
            serif = builtins.head osConfig.desktop.fonts.serif;
            emoji = builtins.head osConfig.desktop.fonts.emoji;
          };
          autoEnable = false;
          targets = {
            font-packages.enable = true;
            fontconfig.enable = true;
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

        gtk = {
          gtk3.extraConfig = {
            "gtk-application-prefer-dark-theme" = "1";
          };
          gtk4.extraConfig = {
            "gtk-application-prefer-dark-theme" = "1";
          };
        };
        dconf = {
          settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
            };
          };
        };

        specialisation = builtins.listToAttrs (
          map (theme: {
            name = theme;
            value = {
              configuration = {
                stylix = {
                  base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
                };
              };
            };
          }) otherThemes
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
      }
    else
      {
        home.activation.removeHmBasePath = ''
          LINK_PATH="''${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/home-manager-base"

          if [[ ! "$0" =~ "specialisation" ]]; then
          	if [ -L "$LINK_PATH" ] || [ -e "$LINK_PATH" ]; then
          		rm -f "$LINK_PATH"
          	fi
          fi
        '';
      };
}
