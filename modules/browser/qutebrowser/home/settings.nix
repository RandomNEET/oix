{
  config,
  lib,
  pkgs,
}:
let
  inherit (lib) getExe;
  startPage = "file://${config.xdg.configHome}/qutebrowser/startpage/index.html";
in
{
  window = {
    hide_decoration = true;
    transparent = true;
  };
  qt = {
    force_platformtheme = "flatpak";
  };
  colors.webpage.darkmode = {
    enabled = true;
    policy.images = "never";
  };
  scrolling = {
    smooth = true;
  };

  tabs = {
    show = "always";
    favicons.scale = 1.0;
    indicator.width = 2;
    title = {
      alignment = "left";
      format = "{audio}{current_title}";
      format_pinned = "{audio}";
    };
  };
  statusbar = {
    widgets = [
      "keypress"
      "search_match"
      "url"
      "progress"
      "scroll"
    ];
  };
  completion = {
    shrink = true;
    height = "30%";
    web_history = {
      exclude = [ ];
      max_items = -1;
    };
  };
  hints.radius = 6;
  keyhint.radius = 10;
  prompt.radius = 12;

  url = {
    default_page = lib.mkDefault startPage;
    start_pages = lib.mkDefault [ startPage ];
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

  editor = lib.optionalAttrs (config.oix.defaults.terminal != null) {
    command = lib.flatten [
      (
        if config.oix.defaults.terminal == "foot" then
          "${pkgs.foot}/bin/foot"
        else
          lib.getExe pkgs.${config.oix.defaults.terminal}
      )
      "-e"
      (
        if config.oix.defaults.editor == "nvim" then
          [
            (getExe config.programs.nixvim.build.package)
            "--clean"
            "--cmd"
            "set clipboard=unnamedplus"
            "--cmd"
            "nnoremap q ZQ"
          ]
        else if config.oix.defaults.editor == "helix" then
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
}
