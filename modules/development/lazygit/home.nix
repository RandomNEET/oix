{
  osConfig,
  config,
  lib,
  ...
}:
{
  programs.lazygit = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      gui = {
        nerdFontsVersion = if (osConfig.oix.desktop.enable or false) then "3" else "2";
      };
      git = {
        paging = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          }
        ];
        parseEmoji = if (osConfig.oix.desktop.enable or false) then true else false;
      };
      os = {
        editPreset = config.oix.defaults.editor or null;
        disableStartupPopups = true;
      };
    };
  };
}
// lib.optionalAttrs (osConfig.oix.desktop.themes.enable or false) {
  stylix.targets.lazygit.enable = true;
}
