{ pkgs, ... }:
{
  home-manager.sharedModules = [
    {
      home = {
        packages = with pkgs; [ trash-cli ];

        shellAliases = {
          tt = "trash-put";
          ttr = "trash-restore";
          ttl = "trash-list";
          tte = "trash-empty";
          ttrm = "trash-rm";
        };
      };
    }
  ];
}
