{
  config,
  lib,
  opts,
  ...
}:
let
  themes = opts.themes or [ ];
  hasThemes = themes != [ ];
  colors = config.lib.stylix.colors;
in
{
  programs.waybar = lib.mkIf hasThemes {
    style = ''
      * {
        font-family: ${config.stylix.fonts.monospace.name}; 
        font-size: 14px;
        font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
        margin: 0px;
        padding: 0px;
      }

      window#waybar {
        transition-property: background-color;
        transition-duration: 0.5s;
        background:  transparent;
        border-radius: 10px;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      tooltip {
        background: #${colors.base00};
        border-radius: 8px;
      }

      tooltip label {
        color: #${colors.base05};
        margin-right: 5px;
        margin-left: 5px;
      }

      .modules-left {
        background: #${colors.base00};
        border: 1px solid #${colors.base0D};
        padding-right: 15px;
        padding-left: 2px;
        border-radius: 10px;
      }

      .modules-center {
        background: #${colors.base00};
        border: 1px solid #${colors.base04};
        padding-right: 5px;
        padding-left: 5px;
        border-radius: 10px;
      }

      .modules-right {
        background: #${colors.base00};
        border: 1px solid #${colors.base0D};
        padding-right: 15px;
        padding-left: 15px;
        border-radius: 10px;
      }

      #backlight,
      #backlight-slider,
      #battery,
      #bluetooth,
      #cava,
      #clock,
      #cpu,
      #disk,
      #idle_inhibitor,
      #keyboard-state,
      #memory,
      #mode,
      #mpris,
      #network,
      #pulseaudio,
      #pulseaudio-slider,
      #taskbar button,
      #taskbar,
      #temperature,
      #tray,
      #window,
      #wireplumber,
      #workspaces,
      #custom-gpuinfo,
      #custom-notification,
      #custom-power {
        padding-top: 3px;
        padding-bottom: 3px;
        padding-right: 6px;
        padding-left: 6px;
      }

      @keyframes blink {
        to {
          color: #${colors.base02};
        }
      }

      #window {
        color: #${colors.base05};
      }

      #light,
      #backlight {
        color: #${colors.base06};
      }

      #audio
      #pulseaudio {
        color: #${colors.base07};
      }

      #pulseaudio.muted,
      #temperature.critical {
        background-color: #${colors.base08};
      }

      #clock,
      #cpu {
        color: #${colors.base0A};
      }

      #battery,
      #memory {
        color: #${colors.base0B};
      }

      #disk,
      #temperature {
        color: #${colors.base0C};
      }

      #bluetooth,
      #idle_inhibitor,
      #language,
      #network {
        color: #${colors.base0D};
      }

      #cava,
      #mpris,
      #pulseaudio.bluetooth {
        color: #${colors.base0E};
      }

      #keyboard-state,
      #custom-gpuinfo {
        color:  #${colors.base0F};
      }

      #workspaces button {
        box-shadow: none;
        text-shadow: none;
        padding: 0px;
        border-radius: 9px;
        background-color: #${colors.base01};
        padding-left: 4px;
        padding-right: 4px;
        transition: all 0.5s cubic-bezier(0.55, -0.68, 0.48, 1.682);
      }

      #workspaces button:hover {
        border-radius: 10px;
        color: #${colors.base03};
        background-color: #${colors.base02};
        padding-left: 2px;
        padding-right: 2px;
        transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
      }

      #workspaces button.active {
        color: #${colors.base09};
        border-radius: 10px;
        padding-left: 8px;
        padding-right: 8px;
        transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
      }

      #workspaces button.urgent {
        color: #${colors.base08};
        border-radius: 0px;
      }

      #battery.critical:not(.charging) {
        background-color: #${colors.base08};
        color: #${colors.base05};
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
        box-shadow: inset 0 -3px transparent;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }

      #taskbar button.active {
        padding-left: 8px;
        padding-right: 8px;
        transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
      }

      #taskbar button:hover {
        padding-left: 2px;
        padding-right: 2px;
        transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
      }

      #network.disconnected,
      #network.disabled {
        background-color: #${colors.base02};
        color: #${colors.base05};
      }

      #pulseaudio-slider slider {
        min-width: 0px;
        min-height: 0px;
        opacity: 0;
        background-image: none;
        border: none;
        box-shadow: none;
      }

      #pulseaudio-slider trough {
        min-width: 80px;
        min-height: 5px;
        border-radius: 5px;
        background-color: #${colors.base02};
      }

      #pulseaudio-slider highlight {
        min-height: 10px;
        border-radius: 5px;
        background-color: #${colors.base0E};
      }

      #backlight-slider slider {
        min-width: 0px;
        min-height: 0px;
        opacity:  0;
        background-image: none;
        border: none;
        box-shadow: none;
      }

      #backlight-slider trough {
        min-width: 80px;
        min-height: 10px;
        border-radius: 5px;
        background-color: #${colors.base02};
      }

      #backlight-slider highlight {
        min-width: 10px;
        border-radius: 5px;
        background-color: #${colors.base0A};
      }

      #custom-notification {
        color: #${colors.base06};
        padding: 0px 5px;
        border-radius: 5px;
      }
    '';
  };
}
