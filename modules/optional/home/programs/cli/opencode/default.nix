{
  osConfig,
  config,
  lib,
  pkgs,
  mylib,
  ...
}:
{
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    mutableSettings = true;
    settings = {
      autoshare = false;
      autoupdate = true;
      agent = {
        explore.disable = true;
        general.disable = true;
      };
      lsp = true;
      plugin = [ "oh-my-opencode-slim" ];
    };
    cli = {
      keybinds = {
        leader = "ctrl+x";
      };
    };
    extraPackages = with pkgs; [
      bun
      nodejs
      uv
    ];
  };
  home = lib.mkMerge [
    {
      file.".config/opencode/oh-my-opencode-slim.jsonc".source = ./plugins/oh-my-opencode-slim.jsonc;
      sessionVariables = {
        OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS = "true";
        OPENCODE_ENABLE_EXA = "1";
      };
    }
    (mylib.util.mkMutableHomeFile {
      inherit config;
      hmLib = lib.hm;
      activationName = "make-opencode-oh-my-opencode-slim-config-mutable";
      fileKey = ".config/opencode/oh-my-opencode-slim.jsonc";
      targetPath = "${config.home.homeDirectory}/.config/opencode/oh-my-opencode-slim.jsonc";
    })
  ];
}
// lib.optionalAttrs osConfig.desktop.themes.enable {
  stylix.targets.opencode.enable = true;
  # TEMPFIX: Stylix still selects its theme through OpenCode 1's tui settings.
  # Remove this imported module once Stylix uses cli.theme.name for OpenCode 2.
  imports = [
    {
      programs.opencode = {
        tui = lib.mkForce { };
        cli.theme.name = "stylix";
      };
    }
  ];
}
