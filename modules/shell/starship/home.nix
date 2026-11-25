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
// lib.optionalAttrs (osConfig.oix.appearance.themes.enable or false) {
  stylix.targets.starship.enable = true;
}
