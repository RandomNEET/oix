{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.oix.defaults = {
    editor = mkOption {
      type = types.nullOr (
        types.enum [
          "nvim"
          "helix"
        ]
      );
      default = null;
      description = "Default text editor used across CLI utilities and desktop keybindings.";
    };
    fileManager = mkOption {
      type = types.nullOr (
        types.enum [
          "yazi"
          "thunar"
        ]
      );
      default = null;
      description = "Default file manager used for desktop keybindings and XDG portal file-chooser integration.";
    };
    terminal = mkOption {
      type = types.nullOr (
        types.enum [
          "kitty"
          "foot"
        ]
      );
      default = null;
      description = "Default terminal emulator exported via `TERMINAL` and used for desktop keybindings and XDG terminal integration.";
    };
    browser = mkOption {
      type = types.nullOr (
        types.enum [
          "qutebrowser"
          "firefox"
          "chromium"
          "w3m"
        ]
      );
      default = null;
      description = "Default web browser exported via `BROWSER` and used for URL handlers and desktop keybindings.";
    };
  };
}
