{ config, lib, ... }:
let
  inherit (lib) mkOption types;
  cfg = config.defaultPrograms;
in
{
  options = {
    defaultPrograms = {
      editor = mkOption {
        type = types.str;
        default = "nvim";
        description = "The command used to launch the default text editor in the terminal.";
      };
      fileManager = mkOption {
        type = types.str;
        default = "yazi";
        description = "The default terminal-based or graphical file manager.";
      };
      terminal = mkOption {
        type = types.str;
        default = "kitty";
        description = "The preferred terminal emulator command for scripts and desktop entries.";
      };
      browser = mkOption {
        type = types.str;
        default = "qutebrowser";
        description = "The command used to launch the default web browser.";
      };
    };
  };
  config = {
    home.sessionVariables = {
      EDITOR = cfg.editor;
      TERMINAL = cfg.terminal;
      BROWSER = cfg.browser;
    };
  };
}
