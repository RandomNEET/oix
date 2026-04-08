{ config, lib, ... }:
let
  inherit (lib) mkOption types optionalAttrs;
  cfg = config.defaultPrograms;
in
{
  options = {
    defaultPrograms = {
      editor = mkOption {
        type = types.enum [
          "nvim"
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
          "none"
        ];
        default = "none";
        description = "The command used to launch the default web browser.";
      };
    };
  };
  config = {
    home.sessionVariables =
      (optionalAttrs (cfg.editor != "none") {
        EDITOR = cfg.editor;
      })
      // (optionalAttrs (cfg.terminal != "none") {
        TERMINAL = cfg.terminal;
      })
      // (optionalAttrs (cfg.browser != "none") {
        BROWSER = cfg.browser;
      });
  };
}
