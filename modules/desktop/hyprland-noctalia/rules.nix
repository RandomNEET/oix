{
  layerrule = [
    "blur on, blur_popups on, ignore_alpha 0.5 , match:namespace noctalia-background-.*$"
    "blur on, ignore_alpha 0.7, match:namespace rofi"
  ];

  windowrule = [
    "opacity 1.00 1.00, match:class ^(org\.qutebrowser\.qutebrowser)$"
    "opacity 1.00 1.00, match:class ^(firefox)$"
    "opacity 0.90 0.90, match:class ^(org\.gnupg\.pinentry-qt)$"
    "opacity 0.90 0.90, match:title ^(Hyprland Polkit Agent)$"
    "opacity 0.80 0.80, match:class ^(kitty|foot|footclient)$"
    "opacity 0.80 0.80, match:class ^(editor)$"
    "opacity 0.80 0.80, match:class ^(terminalFileManager)$"
    "opacity 0.80 0.80, match:class ^(code)$"
    "opacity 0.80 0.80, match:class ^(spotify)$"
    "opacity 0.80 0.80, match:class ^(steam)$"

    "content game, match:tag games"
    "tag +games, match:content game"
    "tag +games, match:class ^(steam_app.*|steam_app_d+)$"
    "tag +games, match:class ^(gamescope)$"
    "tag +games, match:class ^(osu!)$"
    "tag +games, match:class ^(org\.prismlauncher\.PrismLauncher)$"

    "sync_fullscreen on, match:tag games"
    "fullscreen on, match:tag games"
    "border_size 0, match:tag games"
    "no_shadow on, match:tag games"
    "no_blur on, match:tag games"
    "no_anim on, match:tag games"

    "float on, match:title ^(Picture-in-Picture)$, match:class ^(firefox)$"
    "pin on, match:title ^(Picture-in-Picture)$, match:class ^(firefox)$"
    "float on, center on, size 800 1000, match:title Hyprland Keybinds"
  ];
}
