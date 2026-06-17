{
  layer_rule = [
    {
      match = {
        namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$";
      };
      ignore_alpha = 0.5;
      blur = true;
      blur_popups = true;
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
    {
      match = {
        class = "^(terminal filechooser)$";
      };
      opacity = "0.80 0.80";
      float = true;
      size = [
        "(monitor_w*0.8)"
        "(monitor_h*0.8)"
      ];
    }

    # Noctalia settings window
    {
      match = {
        class = "dev.noctalia.Noctalia.Settings";
      };
      float = true;
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
