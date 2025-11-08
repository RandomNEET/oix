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
                aerc.enable = value.aerc.enable or config.programs.aerc.enable;
                mbsync.enable = value.mbsync.enable or config.programs.mbsync.enable;
                thunderbird.enable = value.thunderbird.enable or config.programs.thunderbird.enable;
              }
            ) renamed;
        };
      }
    )
  ];
}
