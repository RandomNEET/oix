{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    defaultPrograms = {
      editor = mkOption {
        type = types.nullOr (
          types.enum [
            "nvim"
            "helix"
          ]
        );
        default = null;
        description = "The command used to launch the default text editor in the terminal.";
      };
      fileManager = mkOption {
        type = types.nullOr (
          types.enum [
            "yazi"
            "thunar"
          ]
        );
        default = null;
        description = "The default terminal-based or graphical file manager.";
      };
      terminal = mkOption {
        type = types.nullOr (
          types.enum [
            "kitty"
            "foot"
          ]
        );
        default = null;
        description = "The preferred terminal emulator command for scripts and desktop entries.";
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
        description = "The command used to launch the default web browser.";
      };
    };
  };
}
