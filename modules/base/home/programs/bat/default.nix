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
}
// lib.optionalAttrs osConfig.desktop.themes.enable {
  stylix.targets.bat.enable = true;
}
