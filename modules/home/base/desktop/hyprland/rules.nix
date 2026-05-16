{
  layer_rule = [
    {
      match = {
        namespace = "noctalia-background-.*$";
      };
      blur = true;
      blur_popups = true;
      ignore_alpha = 0.5;
    }
    {
      match = {
        namespace = "rofi";
      };
      blur = true;
      ignore_alpha = 0.7;
    }
  ];

  window_rule = [
    # Opacity rules
    {
      match = {
        class = "^(org\\.qutebrowser\\.qutebrowser)$";
      };
      opacity = "1.00 1.00";
    }
    {
      match = {
        class = "^([Ff]irefox)$";
      };
      opacity = "1.00 1.00";
    }
    {
      match = {
        class = "^(org\\.gnupg\\.pinentry-qt)$";
      };
      opacity = "0.90 0.90";
    }
    {
      match = {
        title = "^(Hyprland Polkit Agent)$";
      };
      opacity = "0.90 0.90";
    }
    {
      match = {
        class = "^(kitty|foot|footclient)$";
      };
      opacity = "0.80 0.80";
    }
    {
      match = {
        class = "^(editor)$";
      };
      opacity = "0.80 0.80";
    }
    {
      match = {
        class = "^(fileManager)$";
      };
      opacity = "0.80 0.80";
    }
    {
      match = {
        class = "^(code)$";
      };
      opacity = "0.80 0.80";
    }
    {
      match = {
        class = "^([Ss]potify)$";
      };
      opacity = "0.80 0.80";
    }
    {
      match = {
        class = "^([Ss]team)$";
      };
      opacity = "0.80 0.80";
    }

    # Firefox PiP
    {
      match = {
        title = "^(Picture-in-Picture)$";
        class = "^([Ff]irefox)$";
      };
      float = true;
      pin = true;
    }

    # Keybinds popup
    {
      match = {
        title = "Hyprland Keybinds";
      };
      float = true;
      center = true;
      size = "800 1000";
    }

    # Tag games
    {
      match = {
        content = "game";
      };
      tag = "+games";
    }
    {
      match = {
        class = "^(steam_app.*|steam_app_d+)$";
      };
      tag = "+games";
    }
    {
      match = {
        class = "^(gamescope)$";
      };
      tag = "+games";
    }
    {
      match = {
        class = "^(osu!)$";
      };
      tag = "+games";
    }
    {
      match = {
        class = "^(org\\.prismlauncher\\.PrismLauncher)$";
      };
      tag = "+games";
    }

    # Game tag effects
    {
      match = {
        tag = "games";
      };
      content = "game";
      sync_fullscreen = true;
      fullscreen = true;
      border_size = 0;
      no_shadow = true;
      no_blur = true;
      no_anim = true;
    }
  ];
}
