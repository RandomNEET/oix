{
  osConfig,
  config,
  mylib,
  ...
}:
let
  themesEnabled = osConfig.oix.appearance.themes.enable or false;
  colors = if themesEnabled then config.lib.stylix.colors else fallbackColors;
  primaryColor =
    if themesEnabled then
      mylib.theme.getThemePrimaryColor colors config.stylix.base16Scheme
    else
      fallbackColors.base0D;
  polarity = if themesEnabled && config.stylix.polarity == "light" then "light" else "dark";
  ch = hex: i: (builtins.fromTOML "v=0x${builtins.substring i 2 hex}").v;
  hexToRgba =
    hex: alpha:
    "rgba(${toString (ch hex 0)}, ${toString (ch hex 2)}, ${toString (ch hex 4)}, ${toString alpha})";
  mixRgba =
    a: b: ratio: alpha:
    let
      mix = i: toString (builtins.floor ((ch a i) + ((ch b i) - (ch a i)) * ratio + 0.5));
    in
    "rgba(${mix 0}, ${mix 2}, ${mix 4}, ${toString alpha})";
  fallbackColors = {
    base00 = "181818";
    base01 = "282828";
    base02 = "383838";
    base03 = "585858";
    base04 = "b8b8b8";
    base05 = "d8d8d8";
    base06 = "e8e8e8";
    base07 = "f8f8f8";
    base08 = "ab4642";
    base09 = "dc9656";
    base0A = "f7ca88";
    base0B = "a1b56c";
    base0C = "86c1b9";
    base0D = "7cafc2";
    base0E = "ba8baf";
    base0F = "a16946";
  };
in
{
  inherit
    colors
    primaryColor
    polarity
    hexToRgba
    ;
  settings = {
    # Completion
    "colors.completion.category.bg" = hexToRgba colors.base00 1.0;
    "colors.completion.category.border.bottom" = hexToRgba colors.base00 1.0;
    "colors.completion.category.border.top" = hexToRgba colors.base00 1.0;
    "colors.completion.category.fg" = hexToRgba primaryColor 1.0;
    "colors.completion.even.bg" = hexToRgba colors.base00 1.0;
    "colors.completion.odd.bg" = hexToRgba colors.base00 1.0;
    "colors.completion.fg" = hexToRgba colors.base05 1.0;
    "colors.completion.item.selected.bg" = mixRgba colors.base01 primaryColor 0.20 1.0;
    "colors.completion.item.selected.border.bottom" = mixRgba colors.base01 primaryColor 0.20 1.0;
    "colors.completion.item.selected.border.top" = mixRgba colors.base01 primaryColor 0.20 1.0;
    "colors.completion.item.selected.fg" = hexToRgba colors.base06 1.0;
    "colors.completion.item.selected.match.fg" = hexToRgba primaryColor 1.0;
    "colors.completion.match.fg" = hexToRgba primaryColor 1.0;
    "colors.completion.scrollbar.bg" = hexToRgba colors.base00 1.0;
    "colors.completion.scrollbar.fg" = mixRgba colors.base01 colors.base05 0.12 1.0;

    # Context menus
    "colors.contextmenu.menu.bg" = hexToRgba colors.base01 1.0;
    "colors.contextmenu.menu.fg" = hexToRgba colors.base05 1.0;
    "colors.contextmenu.selected.bg" = mixRgba colors.base01 primaryColor 0.20 1.0;
    "colors.contextmenu.selected.fg" = hexToRgba colors.base06 1.0;
    "colors.contextmenu.disabled.bg" = hexToRgba colors.base01 1.0;
    "colors.contextmenu.disabled.fg" = hexToRgba colors.base03 1.0;

    # Downloads
    "colors.downloads.bar.bg" = hexToRgba colors.base01 1.0;
    "colors.downloads.error.bg" = hexToRgba colors.base01 1.0;
    "colors.downloads.start.bg" = hexToRgba colors.base01 1.0;
    "colors.downloads.stop.bg" = hexToRgba colors.base01 1.0;
    "colors.downloads.error.fg" = hexToRgba colors.base08 1.0;
    "colors.downloads.start.fg" = hexToRgba colors.base0D 1.0;
    "colors.downloads.stop.fg" = hexToRgba colors.base0B 1.0;
    "colors.downloads.system.fg" = "none";
    "colors.downloads.system.bg" = "none";

    # Hints
    "colors.hints.bg" = hexToRgba primaryColor 1.0;
    "colors.hints.fg" = hexToRgba colors.base00 1.0;
    "colors.hints.match.fg" = mixRgba primaryColor colors.base00 0.55 1.0;
    "hints.border" = "1px solid ${hexToRgba primaryColor 1.0}";
    "hints.padding" = {
      top = 1;
      bottom = 1;
      left = 5;
      right = 5;
    };

    # Keyhint
    "colors.keyhint.bg" = hexToRgba colors.base01 0.96;
    "colors.keyhint.fg" = hexToRgba colors.base05 1.0;
    "colors.keyhint.suffix.fg" = hexToRgba primaryColor 1.0;

    # Messages
    "colors.messages.error.bg" = mixRgba colors.base01 colors.base08 0.16 1.0;
    "colors.messages.info.bg" = hexToRgba colors.base01 1.0;
    "colors.messages.warning.bg" = mixRgba colors.base01 colors.base09 0.16 1.0;
    "colors.messages.error.border" = mixRgba colors.base01 colors.base08 0.32 1.0;
    "colors.messages.info.border" = mixRgba colors.base01 colors.base05 0.12 1.0;
    "colors.messages.warning.border" = mixRgba colors.base01 colors.base09 0.32 1.0;
    "colors.messages.error.fg" = hexToRgba colors.base08 1.0;
    "colors.messages.info.fg" = hexToRgba colors.base05 1.0;
    "colors.messages.warning.fg" = hexToRgba colors.base09 1.0;

    # Prompts
    "colors.prompts.bg" = hexToRgba colors.base01 1.0;
    "colors.prompts.border" = "1px solid ${mixRgba colors.base01 colors.base05 0.12 1.0}";
    "colors.prompts.fg" = hexToRgba colors.base05 1.0;
    "colors.prompts.selected.bg" = mixRgba colors.base01 primaryColor 0.20 1.0;
    "colors.prompts.selected.fg" = hexToRgba colors.base06 1.0;

    # Statusbar
    "colors.statusbar.normal.bg" = hexToRgba colors.base01 0.82;
    "colors.statusbar.insert.bg" = mixRgba colors.base01 colors.base0B 0.16 1.0;
    "colors.statusbar.command.bg" = hexToRgba colors.base01 1.0;
    "colors.statusbar.caret.bg" = mixRgba colors.base01 colors.base0E 0.16 1.0;
    "colors.statusbar.caret.selection.bg" = mixRgba colors.base01 colors.base09 0.16 1.0;
    "colors.statusbar.progress.bg" = hexToRgba primaryColor 1.0;
    "colors.statusbar.passthrough.bg" = mixRgba colors.base01 colors.base0D 0.16 1.0;
    "colors.statusbar.normal.fg" = hexToRgba colors.base04 1.0;
    "colors.statusbar.insert.fg" = hexToRgba colors.base0B 1.0;
    "colors.statusbar.command.fg" = hexToRgba colors.base05 1.0;
    "colors.statusbar.passthrough.fg" = hexToRgba colors.base0D 1.0;
    "colors.statusbar.caret.fg" = hexToRgba colors.base0E 1.0;
    "colors.statusbar.caret.selection.fg" = hexToRgba colors.base09 1.0;
    "colors.statusbar.url.error.fg" = hexToRgba colors.base08 1.0;
    "colors.statusbar.url.fg" = hexToRgba colors.base04 1.0;
    "colors.statusbar.url.hover.fg" = hexToRgba colors.base0C 1.0;
    "colors.statusbar.url.success.http.fg" = hexToRgba colors.base0A 1.0;
    "colors.statusbar.url.success.https.fg" = hexToRgba colors.base04 1.0;
    "colors.statusbar.url.warn.fg" = hexToRgba colors.base0A 1.0;
    "colors.statusbar.private.bg" = mixRgba colors.base01 colors.base0E 0.22 1.0;
    "colors.statusbar.private.fg" = hexToRgba colors.base05 1.0;
    "colors.statusbar.command.private.bg" = mixRgba colors.base01 colors.base0E 0.22 1.0;
    "colors.statusbar.command.private.fg" = hexToRgba colors.base05 1.0;
    "statusbar.padding" = {
      top = 5;
      bottom = 5;
      left = 12;
      right = 12;
    };

    # Tabs
    "colors.tabs.bar.bg" = hexToRgba colors.base01 0.82;
    "colors.tabs.even.bg" = "transparent";
    "colors.tabs.odd.bg" = "transparent";
    "colors.tabs.even.fg" = hexToRgba colors.base04 1.0;
    "colors.tabs.odd.fg" = hexToRgba colors.base04 1.0;
    "colors.tabs.selected.even.bg" = mixRgba colors.base01 colors.base05 0.10 0.92;
    "colors.tabs.selected.odd.bg" = mixRgba colors.base01 colors.base05 0.10 0.92;
    "colors.tabs.selected.even.fg" = hexToRgba primaryColor 1.0;
    "colors.tabs.selected.odd.fg" = hexToRgba primaryColor 1.0;
    "colors.tabs.pinned.even.bg" = "transparent";
    "colors.tabs.pinned.odd.bg" = "transparent";
    "colors.tabs.pinned.even.fg" = hexToRgba colors.base04 1.0;
    "colors.tabs.pinned.odd.fg" = hexToRgba colors.base04 1.0;
    "colors.tabs.pinned.selected.even.bg" = mixRgba colors.base01 colors.base05 0.10 0.92;
    "colors.tabs.pinned.selected.odd.bg" = mixRgba colors.base01 colors.base05 0.10 0.92;
    "colors.tabs.pinned.selected.even.fg" = hexToRgba primaryColor 1.0;
    "colors.tabs.pinned.selected.odd.fg" = hexToRgba primaryColor 1.0;
    "colors.tabs.indicator.start" = hexToRgba primaryColor 1.0;
    "colors.tabs.indicator.stop" = hexToRgba primaryColor 1.0;
    "colors.tabs.indicator.error" = hexToRgba colors.base08 1.0;
    "colors.tabs.indicator.system" = "none";
    "tabs.padding" = {
      top = 7;
      bottom = 7;
      left = 12;
      right = 12;
    };
  };
}
