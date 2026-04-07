{
  osConfig,
  pkgs,
  mylib,
  ...
}:
{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi.override {
      _7zz = pkgs._7zz-rar;
    };
    enableBashIntegration = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    settings = import ./settings.nix { inherit osConfig mylib; };
    keymap = import ./keymap.nix;
    theme = import ./theme.nix;
    initLua = builtins.readFile ./init.lua; # init.lua for yazi itself
  };
  imports = [ ./plugins ];
}
