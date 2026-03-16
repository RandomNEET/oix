{ opts, ... }:
let
  hasDesktop = opts ? desktop;
in
{
  home-manager.sharedModules = [
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
            editPreset = opts.editor or "";
            disableStartupPopups = true;
          };
        };
      };
    }
  ];
}
