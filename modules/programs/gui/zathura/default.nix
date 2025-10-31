{ ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.zathura = {
        enable = true;
        extraConfig = ''include catppuccin-mocha'';
      };
      home.file.".config/zathura/catppuccin-mocha".source = ./catppuccin-mocha;
    })
  ];
}
