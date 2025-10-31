{ ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
    })
  ];
}
