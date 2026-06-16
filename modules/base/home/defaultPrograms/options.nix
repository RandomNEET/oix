{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    defaultPrograms = {
      editor = mkOption {
        type = types.enum [
          "nvim"
          "helix"
          "none"
        ];
        default = "none";
        description = "The command used to launch the default text editor in the terminal.";
      };
      fileManager = mkOption {
        type = types.enum [
          "yazi"
          "none"
        ];
        default = "none";
        description = "The default terminal-based or graphical file manager.";
      };
      terminal = mkOption {
        type = types.enum [
          "kitty"
          "foot"
          "none"
        ];
        default = "none";
        description = "The preferred terminal emulator command for scripts and desktop entries.";
      };
      browser = mkOption {
        type = types.enum [
          "qutebrowser"
          "firefox"
          "chromium"
          "w3m"
          "none"
        ];
        default = "none";
        description = "The command used to launch the default web browser.";
      };
    };
  };
}
