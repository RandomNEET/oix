{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  hasThemes = osConfig.desktop.themes.enable;
  colors = config.lib.stylix.colors;

  opacity = {
    high = 1.0;
    medium = 0.9;
    low = 0.1;
  };

  hexToRgba =
    hex: alpha:
    let
      r = builtins.fromTOML "v=0x${builtins.substring 0 2 hex}";
      g = builtins.fromTOML "v=0x${builtins.substring 2 2 hex}";
      b = builtins.fromTOML "v=0x${builtins.substring 4 2 hex}";
    in
    "rgba(${toString r.v}, ${toString g.v}, ${toString b.v}, ${toString alpha})";
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
            (
              if config.programs.nixvim.enable then
                "${config.programs.nixvim.build.package}/bin/nvim"
              else
                lib.getExe pkgs.neovim
            )
            "--cmd"
            "nnoremap q ZQ"
          ]
        else
          [
            (lib.getExe pkgs.neovim)
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
    default_page = lib.mkDefault "https://start.duckduckgo.com/";
    start_pages = lib.mkDefault "https://start.duckduckgo.com/";
  };
  colors = {
    webpage = {
      darkmode = {
        enabled = true;
        policy.images = "never";
      };
    };
  }
  // lib.optionalAttrs hasThemes {
    # Completion widget
    completion.category.bg = hexToRgba colors.base00 opacity.high;
    completion.category.border.bottom = hexToRgba colors.base00 opacity.high;
    completion.category.border.top = hexToRgba colors.base03 opacity.high;
    completion.category.fg = hexToRgba colors.base0B opacity.high;

    # Even/odd rows - using same color for simplicity
    completion.even.bg = hexToRgba colors.base00 opacity.high;
    completion.odd.bg = hexToRgba colors.base01 opacity.high;
    completion.fg = hexToRgba colors.base05 opacity.high;

    # Selected completion item
    completion.item.selected.bg = hexToRgba colors.base02 opacity.high;
    completion.item.selected.border.bottom = hexToRgba colors.base02 opacity.high;
    completion.item.selected.border.top = hexToRgba colors.base02 opacity.high;
    completion.item.selected.fg = hexToRgba colors.base05 opacity.high;
    completion.item.selected.match.fg = hexToRgba colors.base06 opacity.high;
    completion.match.fg = hexToRgba colors.base05 opacity.high;

    # Scrollbar
    completion.scrollbar.bg = hexToRgba colors.base01 opacity.high;
    completion.scrollbar.fg = hexToRgba colors.base02 opacity.high;

    # Downloads
    downloads.bar.bg = hexToRgba colors.base00 opacity.high;
    downloads.error.bg = hexToRgba colors.base00 opacity.high;
    downloads.start.bg = hexToRgba colors.base00 opacity.high;
    downloads.stop.bg = hexToRgba colors.base00 opacity.high;

    downloads.error.fg = hexToRgba colors.base08 opacity.high;
    downloads.start.fg = hexToRgba colors.base0D opacity.high;
    downloads.stop.fg = hexToRgba colors.base0B opacity.high;
    downloads.system.fg = "none";
    downloads.system.bg = "none";

    # Hints
    hints.bg = hexToRgba colors.base09 opacity.high;
    hints.fg = hexToRgba colors.base00 opacity.high;
    hints.match.fg = hexToRgba colors.base05 opacity.high;

    # Keyhint widget
    keyhint.bg = hexToRgba colors.base00 opacity.high;
    keyhint.fg = hexToRgba colors.base05 opacity.high;
    keyhint.suffix.fg = hexToRgba colors.base05 opacity.high;

    # Messages
    messages.error.bg = hexToRgba colors.base03 opacity.high;
    messages.info.bg = hexToRgba colors.base03 opacity.high;
    messages.warning.bg = hexToRgba colors.base03 opacity.high;

    messages.error.border = hexToRgba colors.base00 opacity.high;
    messages.info.border = hexToRgba colors.base00 opacity.high;
    messages.warning.border = hexToRgba colors.base00 opacity.high;

    messages.error.fg = hexToRgba colors.base08 opacity.high;
    messages.info.fg = hexToRgba colors.base05 opacity.high;
    messages.warning.fg = hexToRgba colors.base09 opacity.high;

    # Prompts
    prompts.bg = hexToRgba colors.base00 opacity.high;
    prompts.border = "1px solid ${hexToRgba colors.base03 opacity.high}";
    prompts.fg = hexToRgba colors.base05 opacity.high;
    prompts.selected.bg = hexToRgba colors.base02 opacity.high;
    prompts.selected.fg = hexToRgba colors.base0F opacity.high;

    # Statusbar
    statusbar.normal.bg = hexToRgba colors.base00 opacity.medium;
    statusbar.insert.bg = hexToRgba colors.base01 opacity.high;
    statusbar.command.bg = hexToRgba colors.base00 opacity.high;
    statusbar.caret.bg = hexToRgba colors.base00 opacity.high;
    statusbar.caret.selection.bg = hexToRgba colors.base00 opacity.high;
    statusbar.progress.bg = hexToRgba colors.base00 opacity.high;
    statusbar.passthrough.bg = hexToRgba colors.base00 opacity.high;

    statusbar.normal.fg = hexToRgba colors.base05 opacity.high;
    statusbar.insert.fg = hexToRgba colors.base06 opacity.high;
    statusbar.command.fg = hexToRgba colors.base05 opacity.high;
    statusbar.passthrough.fg = hexToRgba colors.base09 opacity.high;
    statusbar.caret.fg = hexToRgba colors.base09 opacity.high;
    statusbar.caret.selection.fg = hexToRgba colors.base09 opacity.high;

    statusbar.url.error.fg = hexToRgba colors.base08 opacity.high;
    statusbar.url.fg = hexToRgba colors.base05 opacity.high;
    statusbar.url.hover.fg = hexToRgba colors.base0C opacity.high;
    statusbar.url.success.http.fg = hexToRgba colors.base0C opacity.high;
    statusbar.url.success.https.fg = hexToRgba colors.base0B opacity.high;
    statusbar.url.warn.fg = hexToRgba colors.base0A opacity.high;

    # Private mode
    statusbar.private.bg = hexToRgba colors.base01 opacity.high;
    statusbar.private.fg = hexToRgba colors.base05 opacity.high;
    statusbar.command.private.bg = hexToRgba colors.base00 opacity.high;
    statusbar.command.private.fg = hexToRgba colors.base04 opacity.high;

    # Tabs
    tabs.bar.bg = hexToRgba colors.base01 opacity.low;
    tabs.even.bg = hexToRgba colors.base03 opacity.low;
    tabs.odd.bg = hexToRgba colors.base04 opacity.low;

    tabs.even.fg = hexToRgba colors.base04 opacity.high;
    tabs.odd.fg = hexToRgba colors.base04 opacity.high;

    tabs.indicator.error = hexToRgba colors.base08 opacity.high;
    tabs.indicator.system = "none";

    tabs.selected.even.bg = hexToRgba colors.base00 opacity.medium;
    tabs.selected.odd.bg = hexToRgba colors.base00 opacity.medium;

    tabs.selected.even.fg = hexToRgba colors.base05 opacity.high;
    tabs.selected.odd.fg = hexToRgba colors.base05 opacity.high;

    # Context menus
    contextmenu.menu.bg = hexToRgba colors.base00 opacity.high;
    contextmenu.menu.fg = hexToRgba colors.base05 opacity.high;

    contextmenu.disabled.bg = hexToRgba colors.base00 opacity.high;
    contextmenu.disabled.fg = hexToRgba colors.base03 opacity.high;

    contextmenu.selected.bg = hexToRgba colors.base02 opacity.high;
    contextmenu.selected.fg = hexToRgba colors.base05 opacity.high;
  };
}
