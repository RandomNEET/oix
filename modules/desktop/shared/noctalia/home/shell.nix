{
  osConfig,
  config,
  lib,
  pkgs,
}:
let
  monoFonts = osConfig.oix.appearance.fonts.monospace or [ ];
  screenshotHandler = lib.getExe (import ./scripts/screenshot-handler.nix { inherit pkgs; });
in
{
  font_family = if monoFonts != [ ] then (builtins.head monoFonts).name else "monospace";
  lang = "en";
  telemetry_enabled = false;
  setup_wizard_enabled = false;
  polkit_agent = true;
  settings_show_advanced = false;
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
    confirm_region = true;
    close_on_copy = true;
    close_on_save = true;
    save_to_file = false;
    copy_to_clipboard = false;
    pipe_to_command = true;
    pipe_command = "${screenshotHandler}";
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
