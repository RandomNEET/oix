{ pkgs, opts, ... }:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs.gpg = {
          enable = true;
          homedir = opts.gpg.homedir or "${config.home.homeDirectory}/.gnupg";
        };
        services.gpg-agent = {
          enable = opts.gpg.agent.enable or false;
          enableSshSupport = opts.gpg.agent.enableSshSupport or false;
          enableBashIntegration = true;
          enableZshIntegration = true;
          pinentry.package = pkgs.pinentry-curses;
          pinentry.program = "pinentry-curses";
        };
        home.packages = [ pkgs.pinentry-all ];
      }
    )
  ];
}
