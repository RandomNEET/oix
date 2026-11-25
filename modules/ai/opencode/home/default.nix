{
  osConfig,
  config,
  lib,
  mylib,
  ...
}:
{
  imports = [
    ../../shared/mcp.nix
    ../../shared/packages.nix
  ]
  ++ lib.optional (osConfig.oix.appearance.themes.enable or false) {
    # TEMPFIX until Stylix uses cli.theme.name for OpenCode 2
    programs.opencode = {
      tui = lib.mkForce { };
      cli.theme.name = "stylix";
    };
  };

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
    context = ../../shared/context.md;
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
// lib.optionalAttrs (osConfig.oix.appearance.themes.enable or false) {
  stylix.targets.opencode.enable = true;
}
