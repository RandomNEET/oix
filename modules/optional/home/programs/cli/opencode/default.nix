{
  osConfig,
  lib,
  pkgs,
  ...
}:
{
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
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
    tui = {
      keybinds = {
        leader = "ctrl+x";
      };
      plugin = [ "oh-my-opencode-slim" ];
    };
    extraPackages = with pkgs; [
      bun
      nodejs
      uv
    ];
  };
  home = {
    file.".config/opencode/oh-my-opencode-slim.jsonc".source = ./plugins/oh-my-opencode-slim.jsonc;
    sessionVariables = {
      OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS = "true";
      OPENCODE_ENABLE_EXA = "1";
    };
  };
}
// lib.optionalAttrs osConfig.desktop.themes.enable {
  stylix.targets.opencode.enable = true;
}
