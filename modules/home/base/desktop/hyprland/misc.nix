{
  config = {
    general = {
      layout = "dwindle";
      border_size = 2;
      gaps_in = 5;
      gaps_out = 10;
    };

    decoration = {
      rounding = 20;
      rounding_power = 2;
      shadow = {
        enabled = true;
        range = 4;
        render_power = 3;
      };
      blur = {
        enabled = true;
        size = 8;
        passes = 3;
        vibrancy = 0.1696;
      };
    };

    input = {
      kb_layout = "us";
      repeat_delay = 300;
      repeat_rate = 30;
      follow_mouse = 1;
      touchpad.natural_scroll = false;
      tablet.output = "current";
      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      force_no_accel = true;
    };

    gestures = {
      gesture = [
        "3, horizontal, workspace"
        "3, up, fullscreen"
        "3, down, close"
      ];
    };

    group = {
      groupbar = {
        font_size = 16;
        height = 30;
      };
    };

    misc = {
      disable_hyprland_logo = true;
      mouse_move_focuses_monitor = true;
      enable_swallow = true;
      swallow_regex = "^(kitty|foot|footclient)$";
      vrr = 3; # enable variable refresh rate (0=off, 1=on, 2=fullscreen only, 3=fullscreen with video or game content type)
    };

    binds = {
      workspace_back_and_forth = 0;
    };

    xwayland.force_zero_scaling = true;

    render = {
      direct_scanout = 2; # 0 = off, 1 = on, 2 = auto (on with content type ‘game’)
    };

    cursor = {
      inactive_timeout = 10;
    };

    ecosystem = {
      no_update_news = true;
      no_donation_nag = true;
    };
  };

  monitor = [
    {
      output = "";
      mode = "preferred";
      position = "auto";
      scale = 1;
    }
  ];
}
