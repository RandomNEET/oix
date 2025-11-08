{ lib, opts, ... }:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        accounts.email = {
          maildirBasePath = opts.email.maildirBasePath or "mail";
          accounts =
            let
              accountAttrs = builtins.removeAttrs opts.email [ "maildirBasePath" ];
              renamed = builtins.listToAttrs (
                builtins.map (element: {
                  name = opts.email.${element}.name or element;
                  value = builtins.removeAttrs opts.email.${element} [ "name" ];
                }) (builtins.attrNames accountAttrs)
              );
            in
            builtins.mapAttrs (
              name: value:
              value
              // {
                aerc = (value.aerc or { }) // {
                  enable = (value.aerc or { }).enable or config.programs.aerc.enable;
                };
                mbsync = (value.mbsync or { }) // {
                  enable = (value.mbsync or { }).enable or config.programs.mbsync.enable;
                };
                thunderbird = (value.thunderbird or { }) // {
                  enable = (value.thunderbird or { }).enable or config.programs.thunderbird.enable;
                };
              }
            ) renamed;
        };
      }
    )
  ];
}
