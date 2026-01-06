{
  home-manager.sharedModules = [
    {
      programs.zathura = {
        enable = true;
        extraConfig = ''
          set selection-clipboard clipboard
        '';
      };
    }
  ];
}
