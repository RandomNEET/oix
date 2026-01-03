{
  home-manager.sharedModules = [
    (_: {
      programs.zathura = {
        enable = true;
        extraConfig = ''
          set selection-clipboard clipboard
        '';
      };
    })
  ];
}
