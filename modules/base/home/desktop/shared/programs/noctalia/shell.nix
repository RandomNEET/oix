{
  osConfig,
  config,
  lib,
  pkgs,
}:
let
  screenshot-handler = lib.getExe (import ./scripts/screenshot-handler.nix { inherit config pkgs; });
in
{
  ui_scale = 1.0;
  font_family = (builtins.head osConfig.desktop.fonts.monospace).name;
  lang = "en";
  time_format = "{:%H:%M}";
  date_format = "%A, %x";
  offline_mode = false;
  telemetry_enabled = false;
  setup_wizard_enabled = true;
  niri_overview_type_to_launch_enabled = false;
  polkit_agent = true;
  password_style = "default";
  settings_show_advanced = false;
  middle_click_opens_widget_settings = true;
  show_location = true;
  app_icon_colorize = false;
  app_icon_color = "on_surface";
  clipboard_enabled = true;
  clipboard_history_max_entries = 100;
  clipboard_confirm_clear_history = true;
  clipboard_auto_paste = "auto";
  clipboard_image_action_command = "";
  shared_gl_context = true;

  animation = {
    enabled = true;
    speed = 1.0;
  };

  shadow = {
    direction = "down";
    alpha = 0.55;
  };

  panel = {
    transparency_mode = "solid";
    borders = true;
    shadow = true;
    launcher_placement = "centered";
    clipboard_placement = "centered";
    control_center_placement = "attached";
    wallpaper_placement = "attached";
    session_placement = "attached";
    open_near_click_control_center = false;
    open_near_click_launcher = false;
    launcher_categories = true;
    launcher_show_icons = true;
    launcher_compact = false;
    launcher_session_search = false;
    open_near_click_clipboard = false;
    open_near_click_wallpaper = false;
    open_near_click_session = false;
  };

  screen_corners = {
    enabled = false;
    size = 32;
  };

  mpris = {
    blacklist = [ ];
  };

  screenshot = {
    directory = config.xdg.userDirs.pictures;
    filename_pattern = "screenshot-%Y-%m-%d-%H:%M:%S";
    freeze_screen = true;
    save_to_file = false;
    copy_to_clipboard = false;
    pipe_to_command = true;
    pipe_command = "${screenshot-handler}";
  };

  session = {
    entries = [
      {
        action = "lock";
        enabled = true;
        shortcut = "1";
      }
      {
        action = "logout";
        enabled = true;
        shortcut = "2";
      }
      {
        action = "lock_and_suspend";
        enabled = true;
        shortcut = "3";
      }
      {
        action = "reboot";
        enabled = true;
        shortcut = "4";
      }
      {
        action = "shutdown";
        enabled = true;
        shortcut = "5";
      }
    ];
  };
}
