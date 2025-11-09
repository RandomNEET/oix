{ opts, ... }:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs.bash = {
          enable = true;
          historyFile = "${config.xdg.dataHome}/bash/history";
          historyFileSize = 100000;

          bashrcExtra = '''' + (opts.bash.bashrcExtra or "");

          initExtra = '''' + (opts.bash.initExtra or "");

          profileExtra = '''' + (opts.bash.profileExtra or "");

          shellAliases = {
            update = "sudo nixos-rebuild switch";
          }
          // (opts.bash.shellAliases or { });
        };
      }
    )
  ];
}
