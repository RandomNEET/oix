{
  config,
  lib,
  opts,
  ...
}:
let
  themes = opts.themes or [ ];
  hasThemes = themes != [ ];
  colors = config.lib.stylix.colors.withHashtag;
in
{
  services.swaync = lib.mkIf hasThemes {
    style = ''
      @define-color shadow rgba(0, 0, 0, 0.25);

      * {
        font-family: ${config.stylix.fonts.monospace.name};
        border-radius: 8px;
      }

      .notification {
        background: ${colors.base00};
        border: 1px solid ${colors.base0D};
        border-radius: 8px;
        margin: 6px 0;
      }

      .notification-action {
        border: 2px solid;
        border-top: none;
      }

      .close-button {
        background: transparent;
        color: transparent;
      }

      /*** Notification ***/
      /* Notification header */
      .summary {
        color: ${colors.base05};
        font-size: 16px;
        background: transparent;
        text-shadow: none;
        font-size: 16px;
      }

      .time {
        color: alpha(${colors.base05}, 0.9);
        font-size: 16px;
        background: transparent;
        font-size: 16px;
        text-shadow: none;
        margin-right: 18px;
      }

      .body {
        background: transparent;
        font-size: 15px;
        font-weight: 500;
        color: ${colors.base05};
        text-shadow: none;
      }

      /* The "Notifications" and "Do Not Disturb" text widget */
      .top-action-title {
        color: ${colors.base05};
        text-shadow: none;
      }

      .control-center {
        background: alpha(${colors.base00}, 0.8);
        border-radius: 8px;
        border: 1px solid ${colors.base0D};
      }

      .control-center .notification-row:focus,
      .control-center .notification-row:hover {
        opacity: 1;
        border-radius: 8px;
      }

      .notification-row {
        outline: none;
        margin: 0;
        padding: 0;
        background: transparent;
        border: none;
      }

      .notification-group {
        background: transparent;
        border: none;
      }

      /*** Widgets ***/

      /* Title widget */
      .widget-title {
        margin: 0px;
        background: transparent;
        border-radius: 4px 4px 0px 0px;
        border-radius: 8px;
        border-bottom: none;
      }

      .widget-title > label {
        margin: 18px 10px;
        font-size: 20px;
        font-weight: 500;
      }

      .widget-title > button {
        font-weight: 700;
        padding: 7px 3px;
        margin-right: 10px;
        background: transparent;
        color: ${colors.base05};
        border: none;
        border-radius: 4px;
      }

      .widget-title > button:hover {
        background: ${colors.base00};
      }

      /* Label widget */
      .widget-label {
        margin: 0px;
        padding: 0px;
        min-height: 5px;
        background: alpha(${colors.base00}, 0.8);
        border-radius: 0px 0px 4px 4px;
        border-top: none;
      }

      .widget-label > label {
        font-size: 15px;
        font-weight: 400;
      }

      /* Menubar */
      .widget-menubar {
        background: transparent;
        border-radius: 4px;
        border-top: none;
        border-bottom: none;
      }

      .widget-menubar > box > box {
        margin: 5px 5px 5px 5px;
        min-height: 40px;
        border-radius: 4px;
        background: transparent;
      }

      .widget-menubar > box > box > button {
        background: alpha(${colors.base00}, 0.8);
        min-width: 185px;
        min-height: 50px;
        margin-right: 25px;
        font-size: 14px;
        padding: 5px;
      }

      .widget-menubar > box > box > button:nth-child(2) {
        margin-right: 0px;
        padding-top: 5px;
      }

      .widget-menubar button:hover {
        background: ${colors.base0D};
        box-shadow: none;
      }

      .widget-menubar > box > revealer > box {
        margin: 5px 10px 5px 10px;
        background: alpha(${colors.base00}, 0.8);
        border-radius: 4px;
      }

      .widget-menubar > box > revealer > box > button {
        background: transparent;
        min-height: 50px;
        padding: 0px;
        margin: 5px;
      }

      /* Buttons grid */
      .widget-buttons-grid {
        background: transparent;
        border-top: none;
        border-bottom: none;
        font-size: 14px;
        font-weight: 500;
        margin: 0px;
        padding: 0px;
        border-radius: 0px;
      }

      .widget-buttons-grid > flowbox > flowboxchild {
        background: ${colors.base00};
        border-radius: 4px;
        min-height: 40px;
        min-width: 85px;
        margin: 5px;
        padding: 0px;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button {
        background: transparent;
        border-radius: 4px;
        margin: 0px;
        border: none;
        box-shadow: none;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button:hover {
        background: ${colors.base0D};
      }

      /* Mpris widget */
      .widget-mpris {
        padding: 8px;
        border-radius: 8px;
        padding-bottom: 15px;
        margin-bottom: 0px;
      }

      .widget-mpris > box > button,
      .widget-mpris-player,
      .widget-mpris-album-art {
        box-shadow: none;
        margin: 10px 0 0 0;
        padding: 5px 10px;
        border-radius: 8px;
      }

      /* Backlight and volume widgets */
      .widget-backlight,
      .widget-volume {
        background: transparent;
        border-top: none;
        border-bottom: none;
        font-size: 13px;
        font-weight: 600;
        border-radius: 0px;
        margin: 0px;
        padding: 0px;
      }

      .widget-volume > box {
        background: alpha(${colors.base00}, 0.8);
        border-radius: 4px;
        margin: 5px 10px 5px 10px;
        min-height: 50px;
      }

      .widget-volume > box > label {
        min-width: 50px;
        padding: 0px;
      }

      .widget-volume > box > button {
        min-width: 50px;
        box-shadow: none;
        padding: 0px;
      }

      .widget-volume > box > button:hover {
        background: ${colors.base02};
      }

      .widget-volume > revealer > list {
        background: alpha(${colors.base00}, 0.8);
        border-radius: 4px;
        margin-top: 5px;
        padding: 0px;
      }

      .widget-volume > revealer > list > row {
        padding-left: 10px;
        min-height: 40px;
        background: transparent;
      }

      .widget-volume > revealer > list > row:hover {
        background: transparent;
        box-shadow: none;
        border-radius: 4px;
      }

      .widget-backlight > scale {
        background: alpha(${colors.base00}, 0.8);
        border-radius: 0px 4px 4px 0px;
        margin: 5px 10px 5px 0px;
        padding: 0px 10px 0px 0px;
        min-height: 50px;
      }

      .widget-backlight > label {
        background: ${colors.base02};
        margin: 5px 0px 5px 10px;
        border-radius: 4px 0px 0px 4px;
        padding: 0px;
        min-height: 50px;
        min-width: 50px;
      }

      /* DND widget */
      .widget-dnd {
        margin: 6px 10px;
        padding: 0 12px;
        font-size: 1.2rem;
      }

      .widget-dnd > switch {
        background: alpha(${colors.base00}, 0.8);
        font-size: initial;
        border-radius: 8px;
        box-shadow: none;
        padding: 2px;
      }

      .widget-dnd > switch:hover {
        background: alpha(${colors.base0D}, 0.8);
      }

      .widget-dnd > switch:checked {
        background: ${colors.base05};
      }

      .widget-dnd > switch:checked:hover {
        background: alpha(${colors.base05}, 0.8);
      }

      .widget-dnd > switch slider {
        background: alpha(${colors.base0D}, 0.8);
        border-radius: 6px;
      }

      /* Toggles */
      .toggle:checked {
        background: ${colors.base03};
      }

      .toggle:checked:hover {
        background: ${colors.base04};
      }

      scale trough {
        border-radius: 4px;
        background: ${colors.base02};
      }

      scale slider {
        background: ${colors.base05};
      }

      scale slider:hover {
      }

      /* Hide scrollbars */
      scrollbar,
      scrollbar * {
        all: unset;
        min-width: 0px;
        min-height: 0px;
      }

      scrollbar slider {
        background: transparent;
      }

      scrollbar.vertical,
      scrollbar.horizontal {
        background: transparent;
      }
    '';
  };
}
