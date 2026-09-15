{
  osConfig,
  config,
  lib,
  pkgs,
  mylib,
  ...
}:
let
  opencodeConfigDir = "${config.xdg.configHome}/opencode";
  opencodeConfigFile = "${opencodeConfigDir}/opencode.json";
  opencodeTuiFile = "${opencodeConfigDir}/tui.json";
in
{
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    settings = {
      autoshare = false;
      autoupdate = true;
      permission = {
        edit = "ask";
        bash = "ask";
      };
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
    };
    extraPackages = with pkgs; [
      bun
      nodejs
      uv
    ];
  };
  home = lib.mkMerge [
    (mylib.util.mkMutableHomeFile {
      inherit config;
      hmLib = lib.hm;
      activationName = "make-opencode-config-mutable";
      fileKey = opencodeConfigFile;
      targetPath = opencodeConfigFile;
    })
    (mylib.util.mkMutableHomeFile {
      inherit config;
      hmLib = lib.hm;
      activationName = "make-opencode-tui-config-mutable";
      fileKey = opencodeTuiFile;
      targetPath = opencodeTuiFile;
    })
    # plugins
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
}
