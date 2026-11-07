{
  osConfig,
  config,
  mylib,
  ...
}:
let
  themesEnabled = osConfig.desktop.themes.enable;
  fallbackColors = {
    base00 = "1e1e2e";
    base01 = "181825";
    base02 = "313244";
    base03 = "45475a";
    base04 = "a6adc8";
    base05 = "cdd6f4";
    base06 = "f5e0dc";
    base07 = "b4befe";
    base08 = "f38ba8";
    base09 = "fab387";
    base0A = "f9e2af";
    base0B = "a6e3a1";
    base0C = "94e2d5";
    base0D = "89b4fa";
    base0E = "cba6f7";
    base0F = "f2cdcd";
  };
  colors = if themesEnabled then config.lib.stylix.colors else fallbackColors;
  primaryColor =
    if themesEnabled then
      mylib.theme.getThemePrimaryColor colors config.stylix.base16Scheme
    else
      fallbackColors.base0E;
  polarity = if themesEnabled && config.stylix.polarity == "light" then "light" else "dark";
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
  inherit
    colors
    primaryColor
    polarity
    hexToRgba
    ;
  settings = {
    # Completion widget
    "colors.completion.category.bg" = hexToRgba colors.base00 1.0;
    "colors.completion.category.border.bottom" = hexToRgba colors.base00 1.0;
    "colors.completion.category.border.top" = hexToRgba colors.base00 1.0;
    "colors.completion.category.fg" = hexToRgba primaryColor 1.0;

    # Alternating completion rows
    "colors.completion.even.bg" = hexToRgba colors.base00 1.0;
    "colors.completion.odd.bg" = hexToRgba colors.base01 1.0;
    "colors.completion.fg" = hexToRgba colors.base05 1.0;

    # Selected completion item
    "colors.completion.item.selected.bg" = hexToRgba colors.base02 1.0;
    "colors.completion.item.selected.border.bottom" = hexToRgba colors.base02 1.0;
    "colors.completion.item.selected.border.top" = hexToRgba colors.base02 1.0;
    "colors.completion.item.selected.fg" = hexToRgba colors.base05 1.0;
    "colors.completion.item.selected.match.fg" = hexToRgba colors.base06 1.0;
    "colors.completion.match.fg" = hexToRgba primaryColor 1.0;

    # Scrollbar
    "colors.completion.scrollbar.bg" = hexToRgba colors.base01 1.0;
    "colors.completion.scrollbar.fg" = hexToRgba colors.base02 1.0;

    # Downloads
    "colors.downloads.bar.bg" = hexToRgba colors.base00 1.0;
    "colors.downloads.error.bg" = hexToRgba colors.base00 1.0;
    "colors.downloads.start.bg" = hexToRgba colors.base00 1.0;
    "colors.downloads.stop.bg" = hexToRgba colors.base00 1.0;

    "colors.downloads.error.fg" = hexToRgba colors.base08 1.0;
    "colors.downloads.start.fg" = hexToRgba colors.base0D 1.0;
    "colors.downloads.stop.fg" = hexToRgba colors.base0B 1.0;
    "colors.downloads.system.fg" = "none";
    "colors.downloads.system.bg" = "none";

    # Hints
    "colors.hints.bg" = hexToRgba primaryColor 1.0;
    "colors.hints.fg" = hexToRgba colors.base00 1.0;
    "colors.hints.match.fg" = hexToRgba colors.base05 1.0;

    # Keyhint widget
    "colors.keyhint.bg" = hexToRgba colors.base00 1.0;
    "colors.keyhint.fg" = hexToRgba colors.base05 1.0;
    "colors.keyhint.suffix.fg" = hexToRgba colors.base05 1.0;

    # Messages
    "colors.messages.error.bg" = hexToRgba colors.base03 1.0;
    "colors.messages.info.bg" = hexToRgba colors.base03 1.0;
    "colors.messages.warning.bg" = hexToRgba colors.base03 1.0;

    "colors.messages.error.border" = hexToRgba colors.base00 1.0;
    "colors.messages.info.border" = hexToRgba colors.base00 1.0;
    "colors.messages.warning.border" = hexToRgba colors.base00 1.0;

    "colors.messages.error.fg" = hexToRgba colors.base08 1.0;
    "colors.messages.info.fg" = hexToRgba colors.base05 1.0;
    "colors.messages.warning.fg" = hexToRgba colors.base09 1.0;

    # Prompts
    "colors.prompts.bg" = hexToRgba colors.base00 1.0;
    "colors.prompts.border" = "1px solid ${hexToRgba colors.base03 1.0}";
    "colors.prompts.fg" = hexToRgba colors.base05 1.0;
    "colors.prompts.selected.bg" = hexToRgba colors.base02 1.0;
    "colors.prompts.selected.fg" = hexToRgba colors.base0F 1.0;

    # Statusbar
    "colors.statusbar.normal.bg" = hexToRgba colors.base00 0.80;
    "colors.statusbar.insert.bg" = hexToRgba colors.base01 1.0;
    "colors.statusbar.command.bg" = hexToRgba colors.base00 0.95;
    "colors.statusbar.caret.bg" = hexToRgba colors.base00 1.0;
    "colors.statusbar.caret.selection.bg" = hexToRgba colors.base00 1.0;
    "colors.statusbar.progress.bg" = hexToRgba colors.base00 1.0;
    "colors.statusbar.passthrough.bg" = hexToRgba colors.base00 1.0;

    "colors.statusbar.normal.fg" = hexToRgba colors.base05 1.0;
    "colors.statusbar.insert.fg" = hexToRgba colors.base06 1.0;
    "colors.statusbar.command.fg" = hexToRgba colors.base05 1.0;
    "colors.statusbar.passthrough.fg" = hexToRgba colors.base09 1.0;
    "colors.statusbar.caret.fg" = hexToRgba colors.base09 1.0;
    "colors.statusbar.caret.selection.fg" = hexToRgba colors.base09 1.0;

    "colors.statusbar.url.error.fg" = hexToRgba colors.base08 1.0;
    "colors.statusbar.url.fg" = hexToRgba colors.base05 1.0;
    "colors.statusbar.url.hover.fg" = hexToRgba colors.base0C 1.0;
    "colors.statusbar.url.success.http.fg" = hexToRgba colors.base0C 1.0;
    "colors.statusbar.url.success.https.fg" = hexToRgba colors.base0B 1.0;
    "colors.statusbar.url.warn.fg" = hexToRgba colors.base0A 1.0;

    # Private mode
    "colors.statusbar.private.bg" = hexToRgba colors.base01 1.0;
    "colors.statusbar.private.fg" = hexToRgba colors.base05 1.0;
    "colors.statusbar.command.private.bg" = hexToRgba colors.base00 1.0;
    "colors.statusbar.command.private.fg" = hexToRgba colors.base04 1.0;

    # Tabs
    "colors.tabs.bar.bg" = hexToRgba colors.base01 0.75;
    "colors.tabs.even.bg" = "transparent";
    "colors.tabs.odd.bg" = "transparent";

    "colors.tabs.even.fg" = hexToRgba colors.base05 1.0;
    "colors.tabs.odd.fg" = hexToRgba colors.base05 1.0;

    "colors.tabs.indicator.error" = hexToRgba colors.base08 1.0;
    "colors.tabs.indicator.system" = "none";

    "colors.tabs.selected.even.bg" = hexToRgba colors.base02 0.85;
    "colors.tabs.selected.odd.bg" = hexToRgba colors.base02 0.85;

    "colors.tabs.selected.even.fg" = hexToRgba primaryColor 1.0;
    "colors.tabs.selected.odd.fg" = hexToRgba primaryColor 1.0;

    # Context menus
    "colors.contextmenu.menu.bg" = hexToRgba colors.base00 1.0;
    "colors.contextmenu.menu.fg" = hexToRgba colors.base05 1.0;

    "colors.contextmenu.disabled.bg" = hexToRgba colors.base00 1.0;
    "colors.contextmenu.disabled.fg" = hexToRgba colors.base03 1.0;

    "colors.contextmenu.selected.bg" = hexToRgba colors.base02 1.0;
    "colors.contextmenu.selected.fg" = hexToRgba colors.base05 1.0;
    "colors.tabs.pinned.even.bg" = "transparent";
    "colors.tabs.pinned.even.fg" = hexToRgba colors.base05 1.0;
    "colors.tabs.pinned.selected.even.bg" = hexToRgba colors.base02 0.85;
    "colors.tabs.pinned.selected.even.fg" = hexToRgba primaryColor 1.0;
    "colors.tabs.pinned.odd.bg" = "transparent";
    "colors.tabs.pinned.odd.fg" = hexToRgba colors.base05 1.0;
    "colors.tabs.pinned.selected.odd.bg" = hexToRgba colors.base02 0.85;
    "colors.tabs.pinned.selected.odd.fg" = hexToRgba primaryColor 1.0;
    "colors.tabs.indicator.start" = hexToRgba primaryColor 1.0;
    "colors.tabs.indicator.stop" = hexToRgba primaryColor 1.0;
  };
}
