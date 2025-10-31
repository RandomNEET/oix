{ ... }:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs.bash = {
          enable = true;
          historyFile = "${config.xdg.dataHome}/bash/history";
          historyFileSize = 100000;

          bashrcExtra = '''';

          initExtra = '''';

          profileExtra = '''';

          shellAliases = {
            update = "sudo nixos-rebuild switch";
          };
        };
      }
    )
  ];
}
