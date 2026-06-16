{
  osConfig,
  config,
  lib,
  ...
}:
{
  programs.helix = {
    enable = true;
    defaultEditor = (config.defaultPrograms.editor == "helix");
    settings = {
      editor = {
        line-number = "relative";
        default-yank-register = "+";
      };
      keys = {
        normal = {
          space = {
            space = "file_picker";
          };
        };
      };
    };
  };

  stylix.targets.helix.enable = lib.mkIf osConfig.desktop.themes.enable true;
}
