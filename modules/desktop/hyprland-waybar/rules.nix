{
  layerrule = [
    "blur on, ignore_alpha 0.7, match:namespace rofi"
    "blur on, ignore_alpha 0.7, match:namespace swaync-control-center"
  ];

  windowrule = [
    # Can use FLOAT FLOAT for active and inactive or just FLOAT
    "opacity 0.80 0.80, match:class ^(kitty|foot|footclient)$"
    "opacity 0.90 0.90, match:class ^(gcr-prompter)$" # keyring prompt
    "opacity 0.90 0.90, match:title ^(Hyprland Polkit Agent)$" # polkit prompt
    "opacity 1.00 1.00, match:class ^(firefox)$"
    "opacity 1.00 1.00, match:class ^(org\.qutebrowser\.qutebrowser)$"
    "opacity 0.80 0.80, match:class ^(Steam)$"
    "opacity 0.80 0.80, match:class ^(steam)$"
    "opacity 0.80 0.80, match:class ^(steamwebhelper)$"
    "opacity 0.80 0.80, match:class ^(Spotify)$"
    "opacity 0.80 0.80, match:title (.*)(Spotify)(.*)$"
    "opacity 0.80 0.80, match:class ^(editor)$"
    "opacity 0.80 0.80, match:class ^(VSCodium)$"
    "opacity 0.80 0.80, match:class ^(codium-url-handler)$"
    "opacity 0.80 0.80, match:class ^(code)$"
    "opacity 0.80 0.80, match:class ^(code-url-handler)$"
    "opacity 0.80 0.80, match:class ^(terminalFileManager)$"
    "opacity 0.80 0.80, match:class ^(org.kde.dolphin)$"
    "opacity 0.80 0.80, match:class ^(org.kde.ark)$"
    "opacity 0.80 0.80, match:class ^(nwg-look)$"
    "opacity 0.80 0.80, match:class ^(qt5ct)$"
    "opacity 0.80 0.80, match:class ^(qt6ct)$"
    "opacity 0.80 0.80, match:class ^(yad)$"

    "opacity 0.90 0.90, match:class ^(com.github.rafostar.Clapper)$" # Clapper-Gtk
    "opacity 0.80 0.80, match:class ^(com.github.tchx84.Flatseal)$" # Flatseal-Gtk
    "opacity 0.80 0.80, match:class ^(hu.kramo.Cartridges)$" # Cartridges-Gtk
    "opacity 0.80 0.80, match:class ^(com.obsproject.Studio)$" # Obs-Qt
    "opacity 0.80 0.80, match:class ^(gnome-boxes)$" # Boxes-Gtk
    "opacity 0.90 0.90, match:class ^(discord)$" # Discord-Electron
    "opacity 0.90 0.90, match:class ^(WebCord)$" # WebCord-Electron
    "opacity 0.80 0.80, match:class ^(app.drey.Warp)$" # Warp-Gtk
    "opacity 0.80 0.80, match:class ^(net.davidotek.pupgui2)$" # ProtonUp-Qt
    "opacity 0.80 0.80, match:class ^(Signal)$" # Signal-Gtk
    "opacity 0.80 0.80, match:class ^(io.gitlab.theevilskeleton.Upscaler)$" # Upscaler-Gtk

    "opacity 0.80 0.70, match:class ^(pavucontrol)$"
    "opacity 0.80 0.70, match:class ^(org.pulseaudio.pavucontrol)$"
    "opacity 0.80 0.70, match:class ^(blueman-manager)$"
    "opacity 0.80 0.70, match:class ^(.blueman-manager-wrapped)$"
    "opacity 0.80 0.70, match:class ^(nm-applet)$"
    "opacity 0.80 0.70, match:class ^(nm-connection-editor)$"
    "opacity 0.80 0.70, match:class ^(org.kde.polkit-kde-authentication-agent-1)$"

    "content game, match:tag games"
    "tag +games, match:content game"
    "tag +games, match:class ^(steam_app.*|steam_app_d+)$"
    "tag +games, match:class ^(gamescope)$"
    "tag +games, match:class (Waydroid)"
    "tag +games, match:class (osu!)"

    # Games
    "sync_fullscreen on, match:tag games"
    "fullscreen on, match:tag games"
    "border_size 0, match:tag games"
    "no_shadow on, match:tag games"
    "no_blur on, match:tag games"
    "no_anim on, match:tag games"

    "float on, center on, size 800 1000, match:title Hyprland Keybinds"
    "float on, match:title ^(Picture-in-Picture)$, match:class ^(firefox)$"
    "pin on, match:title ^(Picture-in-Picture)$, match:class ^(firefox)$"

    "float on, match:class ^(qt5ct)$"
    "float on, match:class ^(nwg-look)$"
    "float on, match:class ^(org.kde.ark)$"
    "float on, match:class ^(Signal)$" # Signal-Gtk
    "float on, match:class ^(com.github.rafostar.Clapper)$" # Clapper-Gtk
    "float on, match:class ^(app.drey.Warp)$" # Warp-Gtk
    "float on, match:class ^(net.davidotek.pupgui2)$" # ProtonUp-Qt
    "float on, match:class ^(eog)$" # Imageviewer-Gtk
    "float on, match:class ^(io.gitlab.theevilskeleton.Upscaler)$" # Upscaler-Gtk
    "float on, match:class ^(yad)$"
    "float on, match:class ^(pavucontrol)$"
    "float on, match:class ^(blueman-manager)$"
    "float on, match:class ^(.blueman-manager-wrapped)$"
    "float on, match:class ^(nm-applet)$"
    "float on, match:class ^(nm-connection-editor)$"
    "float on, match:class ^(org.kde.polkit-kde-authentication-agent-1)$"
  ];
}
