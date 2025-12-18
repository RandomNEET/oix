{ pkgs, opts, ... }:
{
  home-manager.sharedModules = [
    (
      { lib, ... }:
      {
        i18n.inputMethod = {
          enable = true;
          type = "fcitx5";
          fcitx5 = {
            waylandFrontend = true;
            addons =
              with pkgs;
              [ fcitx5-rime-ice ]
              ++ lib.optionals ((opts.theme or "") == "catppuccin-mocha") [ catppuccin-fcitx5 ];
            settings = {
              inputMethod = {
                GroupOrder."0" = "Default";
                "Groups/0" = {
                  Name = "Default";
                  "Default Layout" = "us";
                  DefaultIM = "rime";
                };
                "Groups/0/Items/0".Name = "keyboard-us";
                "Groups/0/Items/1".Name = "rime";
              };
              globalOptions = {
                Behavior = {
                  ActiveByDefault = false;
                };
                Hotkey = {
                  EnumerateWithTriggerKeys = true;
                  EnumerateSkipFirst = false;
                  ModifierOnlyKeyTimeout = 250;
                };
                "Hotkey/TriggerKeys" = {
                  "0" = "Shift+Control_L";
                };
              };
              addons = {
                classicui.globalSection = {
                  Font = "JetBrainsMono Nerd Font 10";
                  MenuFont = "JetBrainsMono Nerd Font 10";
                  TrayFont = "JetBrainsMono Nerd Font 10";
                  TrayOutlineColor = "#000000";
                  TrayTextColor = "#ffffff";
                  UserAccentColor = false;
                }
                // lib.optionalAttrs ((opts.theme or "") == "catppuccin-mocha") {
                  Theme = "catppuccin-mocha-mauve";
                  DarkTheme = "catppuccin-mocha-mauve";
                };
                keyboard.globalSection = {
                  EmojiEnabled = true;
                };
                rime.globalSection = {
                  SwitchInputMethodBehavior = "Commit raw input";
                };
              };
            };
          };
        };
        home = {
          activation.copyRimeIce = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            mkdir -p $HOME/.local/share/fcitx5/rime
            cp -r ${pkgs.rime-ice}/share/rime-data/* $HOME/.local/share/fcitx5/rime/
            chown -R $USER:users $HOME/.local/share/fcitx5/rime
            chmod -R u+rwX $HOME/.local/share/fcitx5/rime
          '';
          file = {
            ".local/share/fcitx5/rime/default.custom.yaml".source = ./rime/default.custom.yaml;
            ".local/share/fcitx5/rime/rime_ice.custom.yaml".source = ./rime/rime_ice.custom.yaml;
          };
        };
      }
    )
  ];
  # Enable for xwayland
  environment.variables = {
    XMODIFIERS = "@im=fcitx";
  };
}
