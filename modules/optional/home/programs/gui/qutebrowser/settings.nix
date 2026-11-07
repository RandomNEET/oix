{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
  startPage = "file://${config.xdg.configHome}/qutebrowser/startpage/index.html";
in
{
  completion = {
    shrink = true;
    height = "30%";
    web_history = {
      exclude = [ ];
      max_items = (-1);
    };
  };
  editor = {
    command = lib.flatten [
      (
        if config.defaultPrograms.terminal == "foot" then
          "${pkgs.foot}/bin/foot"
        else
          lib.getExe pkgs.${config.defaultPrograms.terminal}
      )
      "-e"
      (
        if config.defaultPrograms.editor == "nvim" then
          [
            (getExe config.programs.nixvim.build.package)
            "--clean"
            "--cmd"
            "set clipboard=unnamedplus"
            "--cmd"
            "nnoremap q ZQ"
          ]
        else if config.defaultPrograms.editor == "helix" then
          [ (getExe pkgs.helix) ]
        else
          [
            (getExe pkgs.neovim)
            "--clean"
            "--cmd"
            "set clipboard=unnamedplus"
            "--cmd"
            "nnoremap q ZQ"
          ]
      )
      "{file}"
    ];
  };
  window = {
    hide_decoration = true;
    transparent = true;
  };
  tabs = {
    show = "always";
    indicator.width = 2;
  };
  scrolling = {
    smooth = true;
  };
  content = {
    blocking = {
      enabled = true;
      method = "auto";
      hosts = {
        block_subdomains = true;
        lists = [
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
        ];
      };
      whitelist = [ ];
    };
  };
  url = {
    default_page = lib.mkDefault startPage;
    start_pages = lib.mkDefault [ startPage ];
  };
  colors.webpage.darkmode = {
    enabled = true;
    policy.images = "never";
  };
  qt = {
    force_platformtheme = "flatpak";
  };
}
