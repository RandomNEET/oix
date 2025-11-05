{ lib, opts, ... }:
{
  home-manager.sharedModules = [
    (
      _:
      {
        programs.zathura = {
          enable = true;
          extraConfig = ''
            ${lib.optionalString ((opts.theme or "") != "") "include ${opts.theme}"}
          '';
        };
      }
      // lib.optionalAttrs ((opts.theme or "") != "") {
        home.file = {
          ".config/zathura/${opts.theme}".source = ./${opts.theme};
        };
      }
    )
  ];
}
