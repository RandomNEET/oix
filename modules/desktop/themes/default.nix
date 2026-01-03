{
  inputs,
  lib,
  pkgs,
  opts,
  ...
}:
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    autoEnable = false;
    targets = {
      console.enable = true;
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${opts.theme}.yaml";
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

  specialisation = {
    everforest-dark-hard.configuration = {
      stylix = {
        base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
      };
    };
    gruvbox-dark-hard.configuration = {
      stylix = {
        base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
      };
    };
    kanagawa.configuration = {
      stylix = {
        base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
      };
    };
    nord.configuration = {
      stylix = {
        base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/nord.yaml";
      };
    };
  };

  home-manager.sharedModules = [
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
      }
    )
  ];
}
