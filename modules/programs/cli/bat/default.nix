{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.bat = {
        enable = true;
        config = {
          style = "plain";
          theme = "catppuccin-mocha";
        };
        themes = {
          catppuccin-mocha = {
            src = pkgs.fetchFromGitHub {
              owner = "catppuccin";
              repo = "bat";
              rev = "main";
              sha256 = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
            };
            file = "themes/Catppuccin Mocha.tmTheme";
          };
        };
      };
    })
  ];
}
