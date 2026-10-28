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
  font_family = (builtins.head osConfig.desktop.fonts.monospace).name;
  lang = "en";
  telemetry_enabled = false;
  setup_wizard_enabled = false;
  polkit_agent = true;
  settings_show_advanced = false;
  app_icon_colorize = false;
  clipboard_enabled = true;
  clipboard_image_action_command = "satty --filename {path}";

  animation = {
    enabled = true;
  };

  screen_corners = {
    enabled = false;
  };

  screenshot = {
    annotate = true;
    save_to_file = false;
    copy_to_clipboard = false;
    pipe_to_command = true;
    pipe_command = "${screenshot-handler}";
    directory = "${config.xdg.userDirs.pictures}/screenshots";
    filename_pattern = "screenshot-%Y-%m-%d-%H:%M:%S";
  };

  session = {
    actions = [
      {
        enabled = true;
        action = "lock";
        shortcut = "1";
      }
      {
        enabled = true;
        action = "logout";
        shortcut = "2";
      }
      {
        enabled = true;
        action = "lock_and_suspend";
        shortcut = "3";
      }
      {
        enabled = true;
        action = "reboot";
        shortcut = "4";
      }
      {
        enabled = true;
        action = "shutdown";
        shortcut = "5";
      }
    ];
  };
}
