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
        nerdFontsVersion = if osConfig.desktop.enable then "3" else "2";
      };
      git = {
        paging = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          }
        ];
        overrideGpg = true;
        parseEmoji = if osConfig.desktop.enable then true else false;
      };
      os = {
        editPreset = config.defaultPrograms.editor;
        disableStartupPopups = true;
      };
    };
  };

  stylix.targets.lazygit.enable = lib.mkIf osConfig.desktop.themes.enable true;
}
