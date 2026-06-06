{
  osConfig,
  lib,
  pkgs,
  ...
}:
{
  programs.bat = {
    enable = true;
    config = {
      style = "numbers,changes";
      italic-text = "always";
      wrap = "never";
      pager = "less -RFKX";
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
  };

  home.sessionVariables = {
    MANPAGER = "bat -plman";
  };

  stylix.targets.bat.enable = lib.mkIf osConfig.desktop.themes.enable true;
}
