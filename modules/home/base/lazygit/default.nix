{ osConfig, config, ... }:
let
  hasDesktop = osConfig.desktop.enable;
in
{
  programs.lazygit = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      gui = {
        nerdFontsVersion = if hasDesktop then "3" else "2";
      };
      git = {
        paging = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          }
        ];
        overrideGpg = true;
        parseEmoji = if hasDesktop then true else false;
      };
      os = {
        editPreset = config.defaultPrograms.editor;
        disableStartupPopups = true;
      };
    };
  };
}
