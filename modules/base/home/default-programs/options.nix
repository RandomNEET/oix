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
        description = ''
          Default text editor used across CLI tools and desktop keybindings.
          Setting this option automatically enables the selected editor.
        '';
      };
      nvim.enable = mkEnableOption "Neovim, a hyperextensible Vim-based text editor";
      helix.enable = mkEnableOption "Helix, a post-modern modal text editor";
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
        description = ''
          Default file manager used for desktop keybindings and XDG portal file-chooser integration.
          Setting this option automatically enables the selected file manager.
        '';
      };
      yazi.enable = mkEnableOption "Yazi, a blazing fast terminal file manager written in Rust";
      thunar.enable = mkEnableOption "Thunar, the Xfce file manager";
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
        description = ''
          Default terminal emulator exported via `TERMINAL` and used for desktop keybindings and XDG terminal integration.
          Setting this option automatically enables the selected terminal emulator.
        '';
      };
      kitty.enable = mkEnableOption "kitty, a fast, feature-rich, GPU-based terminal emulator";
      foot.enable = mkEnableOption "foot, a fast, lightweight, and minimalistic Wayland terminal emulator";
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
        description = ''
          Default web browser exported via `BROWSER` and used for URL handlers and desktop keybindings.
          Setting this option automatically enables the selected browser.
        '';
      };
      qutebrowser.enable = mkEnableOption "qutebrowser, a keyboard-focused browser with a minimal GUI";
      firefox.enable = mkEnableOption "Firefox, a free and open-source web browser developed by Mozilla";
      chromium.enable = mkEnableOption "Chromium, an open-source web browser from The Chromium Project";
      w3m.enable = mkEnableOption "the w3m terminal web browser";
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
