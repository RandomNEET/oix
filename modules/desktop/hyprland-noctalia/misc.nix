{ opts, ... }:
{
  input = {
    kb_layout = "${opts.kbdLayout}";
    kb_variant = "${opts.kbdVariant or ""}";

    repeat_delay = 300;
    repeat_rate = 30;

    follow_mouse = 1;

    touchpad.natural_scroll = false;

    tablet.output = "current";

    sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
    force_no_accel = true;
  };

  general = {
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

  group = {
    groupbar = {
      font_size = 16;
      height = 30;
    };
  };

  animations = {
    enabled = true;
    bezier = [
      "linear, 0, 0, 1, 1"
      "md3_standard, 0.2, 0, 0, 1"
      "md3_decel, 0.05, 0.7, 0.1, 1"
      "md3_accel, 0.3, 0, 0.8, 0.15"
      "overshot, 0.05, 0.9, 0.1, 1.1"
      "crazyshot, 0.1, 1.5, 0.76, 0.92"
      "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
      "fluent_decel, 0.1, 1, 0, 1"
      "easeInOutCirc, 0.85, 0, 0.15, 1"
      "easeOutCirc, 0, 0.55, 0.45, 1"
      "easeOutExpo, 0.16, 1, 0.3, 1"
    ];
    animation = [
      "windows, 1, 3, md3_decel, popin 60%"
      "border, 1, 10, default"
      "fade, 1, 2.5, md3_decel"
      "workspaces, 1, 3.5, easeOutExpo, slide"
      "specialWorkspace, 1, 3, md3_decel, slidevert"
    ];
  };

  render = {
    direct_scanout = 2; # 0 = off, 1 = on, 2 = auto (on with content type ‘game’)
  };

  cursor = {
    inactive_timeout = 5;
  };

  gestures = {
    gesture = [
      "3, horizontal, workspace"
      "3, up, fullscreen"
      "3, down, close"
    ];
  };

  dwindle = {
    pseudotile = true;
    preserve_split = true;
  };

  master = {
    new_status = "master";
    new_on_top = true;
    mfact = 0.5;
  };

  ecosystem = {
    no_update_news = true;
    no_donation_nag = true;
  };

  misc = {
    disable_hyprland_logo = true;
    mouse_move_focuses_monitor = true;
    enable_swallow = true;
    swallow_regex = "^(kitty|foot|footclient)$";
    vfr = true; # always keep on
    vrr = 1; # enable variable refresh rate (0=off, 1=on, 2=fullscreen only)
  };

  xwayland.force_zero_scaling = true;

  monitor = opts.hyprland.settings.monitor or [ ];
}
