{ config, lib, ... }:
let
  inherit (lib)
    mkOption
    mkEnableOption
    types
    mkIf
    mkMerge
    mkForce
    ;
in
{
  options.defaultPrograms = {
    editor = {
      default = mkOption {
        type = types.nullOr (
          types.enum [
            "nvim"
            "helix"
          ]
        );
        default = null;
        description = "The default editor program";
      };
      nvim.enable = mkEnableOption "nvim configuration";
      helix.enable = mkEnableOption "helix configuration";
    };
    fileManager = {
      default = mkOption {
        type = types.nullOr (
          types.enum [
            "yazi"
            "thunar"
          ]
        );
        default = null;
        description = "The default fileManager program";
      };
      yazi.enable = mkEnableOption "yazi configuration";
      thunar.enable = mkEnableOption "thunar configuration";
    };
    terminal = {
      default = mkOption {
        type = types.nullOr (
          types.enum [
            "kitty"
            "foot"
          ]
        );
        default = null;
        description = "The default terminal program";
      };
      kitty.enable = mkEnableOption "kitty configuration";
      foot.enable = mkEnableOption "foot configuration";
    };
    browser = {
      default = mkOption {
        type = types.nullOr (
          types.enum [
            "qutebrowser"
            "firefox"
            "chromium"
            "w3m"
          ]
        );
        default = null;
        description = "The default browser program";
      };
      qutebrowser.enable = mkEnableOption "qutebrowser configuration";
      firefox.enable = mkEnableOption "firefox configuration";
      chromium.enable = mkEnableOption "chromium configuration";
      w3m.enable = mkEnableOption "w3m configuration";
    };
  };

  config = mkMerge [
    (mkIf (config.defaultPrograms.editor.default == "nvim") {
      defaultPrograms.editor.nvim.enable = mkForce true;
    })
    (mkIf (config.defaultPrograms.editor.default == "helix") {
      defaultPrograms.editor.helix.enable = mkForce true;
    })
    (mkIf (config.defaultPrograms.fileManager.default == "yazi") {
      defaultPrograms.fileManager.yazi.enable = mkForce true;
    })
    (mkIf (config.defaultPrograms.fileManager.default == "thunar") {
      defaultPrograms.fileManager.thunar.enable = mkForce true;
    })
    (mkIf (config.defaultPrograms.terminal.default == "kitty") {
      defaultPrograms.terminal.kitty.enable = mkForce true;
    })
    (mkIf (config.defaultPrograms.terminal.default == "foot") {
      defaultPrograms.terminal.foot.enable = mkForce true;
    })
    (mkIf (config.defaultPrograms.browser.default == "qutebrowser") {
      defaultPrograms.browser.qutebrowser.enable = mkForce true;
    })
    (mkIf (config.defaultPrograms.browser.default == "firefox") {
      defaultPrograms.browser.firefox.enable = mkForce true;
    })
    (mkIf (config.defaultPrograms.browser.default == "chromium") {
      defaultPrograms.browser.chromium.enable = mkForce true;
    })
    (mkIf (config.defaultPrograms.browser.default == "w3m") {
      defaultPrograms.browser.w3m.enable = mkForce true;
    })
  ];
}
