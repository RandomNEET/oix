{ opts, ... }:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs.password-store = {
          enable = true;
          settings = {
            PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
          }
          // (opts.password-store or { });
        };
      }
    )
  ];
}
