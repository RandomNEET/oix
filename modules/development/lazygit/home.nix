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
        nerdFontsVersion = "3";
      };
      git = {
        paging = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          }
        ];
        parseEmoji = true;
      };
      os = {
        editPreset = config.oix.defaults.editor;
        disableStartupPopups = true;
      };
    };
  };
}
// lib.optionalAttrs (osConfig.oix.appearance.themes.enable or false) {
  stylix.targets.lazygit.enable = true;
}
