{
  osConfig,
  config,
  lib,
  ...
}:
{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    configPath = "${config.xdg.configHome}/starship/starship.toml";
    presets = [ "nerd-font-symbols" ];
    settings = {
      add_newline = false;
      format = lib.concatStrings [ "$all" ];
    };
  };
}
// lib.optionalAttrs osConfig.desktop.themes.enable {
  stylix.targets.starship.enable = true;
}
