{
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkMerge mkIf;
in
{
  config = mkMerge [
    (mkIf (osConfig.desktop.enable && osConfig.desktop.themes.enable) (
      let
        defaultTheme = builtins.head osConfig.desktop.themes.list;
        otherThemes = builtins.tail osConfig.desktop.themes.list;
      in
      {
        stylix = {
          enable = true;
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
            bat.enable = true;
            btop.enable = true;
            cava.enable = true;
            fcitx5.enable = true;
            firefox = {
              enable = true;
              profileNames = [ "default" ];
            };
            font-packages.enable = true;
            fontconfig.enable = true;
            foot.enable = true;
            fzf.enable = true;
            gtk = {
              enable = true;
              flatpakSupport.enable = true;
            };
            hyprland.enable = true;
            kitty.enable = true;
            lazygit.enable = true;
            mpv.enable = true;
            nixvim = {
              enable = true;
              transparentBackground = {
                main = true;
                numberLine = true;
                signColumn = true;
              };
            };
            obsidian.enable = true;
            opencode.enable = true;
            qt.enable = true;
            spicetify.enable = true;
            spotify-player.enable = true;
            tmux.enable = false;
            vesktop.enable = true;
            vscode.enable = true;
            waybar.enable = true;
            yazi.enable = true;
            zathura.enable = true;
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
    ))
    (mkIf (osConfig.desktop.enable && !osConfig.desktop.themes.enable) {
      home.activation.saveHmBasePath = ''
        LINK_PATH="''${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/home-manager-base"

        if [[ ! "$0" =~ "specialisation" ]]; then
        	if [ -L "$LINK_PATH" ] || [ -e "$LINK_PATH" ]; then
        		rm -f "$LINK_PATH"
        	fi
        fi
      '';
    })
    (mkIf (!osConfig.desktop.enable) {
      stylix = {
        enable = false;
        autoEnable = false;
        overlays.enable = false;
      };
    })
  ];
}
