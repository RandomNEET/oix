{ lib, opts, ... }:
{
  home-manager.sharedModules = [
    (
      _:
      {
        programs.zathura = {
          enable = true;
          extraConfig = ''
            set selection-clipboard clipboard
          ''
          + lib.optionalString ((opts.theme or "") != "") "include themes/${opts.theme}";
        };
      }
      // lib.optionalAttrs ((opts.theme or "") != "") {
        home.file = {
          ".config/zathura/themes".source = ./themes;
        };
      }
    )
  ];
}
