{
  inputs,
  lib,
  pkgs,
  opts,
  ...
}:
let
  themes = opts.themes or [ ];
  hasThemes = themes != [ ];
  defaultTheme = if hasThemes then builtins.head themes else "";
  otherThemes = if hasThemes then builtins.tail themes else [ ];
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = lib.mkIf hasThemes {
    enable = true;
    autoEnable = false;
    targets = {
      console.enable = true;
    };
    base16Scheme = lib.mkIf hasThemes "${pkgs.base16-schemes}/share/themes/${defaultTheme}.yaml";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  home-manager.sharedModules = lib.mkIf hasThemes [
    (
      { config, ... }:
      {
        stylix = {
          polarity = "dark";
          targets = {
            bat.enable = true;
            btop.enable = true;
            cava.enable = true;
            fcitx5.enable = true;
            firefox.enable = true;
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
            tmux.enable = true;
            vencord.enable = true;
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
          iconTheme = {
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

        specialisation = lib.mkIf hasThemes (
          builtins.listToAttrs (
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
          )
        );

        home.activation.saveHmBasePath = ''
          if [[ ! "$0" =~ "specialisation" ]]; then
            LINK_PATH="''${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/home-manager-base"
            
            mkdir -p "$(dirname "$LINK_PATH")"
            
            REAL_SELF=$(readlink -f "$0")
            BASE_GEN=''${REAL_SELF%/activate}
            
            if [ -d "$BASE_GEN/specialisation" ]; then
              ln -sfn "$BASE_GEN" "$LINK_PATH"
              verboseEcho "Linked $LINK_PATH -> $BASE_GEN"
            fi
          fi
        '';
      }
    )
  ];
}
