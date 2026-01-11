{ pkgs, opts, ... }:
let
  desktop = opts.desktop or "";
  hasDesktop = desktop != "";
in
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
          enable = opts.gpg.gpg-agent.enable or false;
          enableSshSupport = opts.gpg.gpg-agent.enableSshSupport or false;
          enableBashIntegration = true;
          enableZshIntegration = true;
          pinentry.package = if hasDesktop then pkgs.pinentry-qt else pkgs.pinentry-curses;
          pinentry.program = if hasDesktop then "pinentry-qt" else "pinentry-curses";
        };
        home.packages = [ pkgs.pinentry-all ];
      }
    )
  ];
}
