{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          waylandFrontend = true;
          addons = with pkgs; [
            fcitx5-chinese-addons
            catppuccin-fcitx5
          ];
          settings = {
            inputMethod = {
              GroupOrder."0" = "Default";
              "Groups/0" = {
                Name = "Default";
                "Default Layout" = "us";
                DefaultIM = "pinyin";
              };
              "Groups/0/Items/0".Name = "keyboard-us";
              "Groups/0/Items/1".Name = "pinyin";
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
              "Behavior/DisabledAddons" = {
                "0" = "cloudpinyin";
              };
              "Hotkey/TriggerKeys" = {
                "0" = "Shift+Control_L";
                "1" = "Zenkaku_Hankaku";
                "2" = "Hangul";
              };
            };
            addons = {
              classicui.globalSection = {
                Font = "JetBrainsMono Nerd Font 10";
                MenuFont = "JetBrainsMono Nerd Font 10";
                TrayFont = "JetBrainsMono Nerd Font 10";
                TrayOutlineColor = "#000000";
                TrayTextColor = "#ffffff";
                Theme = "catppuccin-mocha-mauve";
                DarkTheme = "catppuccin-mocha-mauve";
                UserAccentColor = false;
              };
              keyboard.globalSection = {
                EmojiEnabled = true;
                "Hint Trigger" = "";
                "One Time Hint Trigger" = "";
              };
              pinyin.globalSection = {
                FirstRun = false;
              };
            };
          };
        };
      };
    })
  ];
  # Enable for xwayland
  environment.variables = {
    XMODIFIERS = "@im=fcitx";
  };
}
