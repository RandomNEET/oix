{ osConfig, lib }:
let
  inherit (lib) optionalAttrs;
in
{
  workspaces = {
    type = "workspaces";
    hide_when_empty = true;
  };
  taskbar = {
    type = "taskbar";
    only_active_workspace = true;
  };
  media = {
    type = "media";
    title_scroll = "always";
    rotate_album_art = true;
    show_progress = true;
    hide_when_no_media = true;
  };
  audio_visualizer = {
    type = "audio_visualizer";
  };
  clock = {
    type = "clock";
    format = "{:%a %b %e %H:%M}";
    vertical_format = "{:%m %d - %H %M}";
    tooltip_format = "{:%Y-%m-%d %H:%M:%S}";
  };
  cpu = {
    type = "sysmon";
    stat = "cpu_usage";
  };
  ram = {
    type = "sysmon";
    stat = "ram_used";
  };
  network = {
    type = "network";
    show_label = false;
  };
  bluetooth = {
    type = "bluetooth";
    show_label = false;
    hide_when_adapter_off = true;
  };
  brightness = {
    type = "brightness";
  };
  output_volume = {
    type = "volume";
  };
  battery = {
    type = "battery";
  };
  keyboard_layout = {
    type = "keyboard_layout";
    hide_when_single_layout = true;
  };
  tray = {
    type = "tray";
    drawer = true;
    match_adjacent_spacing = true;
  };
  notifications = {
    type = "notifications";
    hide_when_no_unread = false;
  };
  control-center = {
    type = "control-center";
    glyph = "dots";
  };
}
// optionalAttrs osConfig.services.dae.enable {
  proxy-dae = {
    type = "custom/systemd-service:service";
    glyph = "network";
    service = "dae.service";
  };
}
// optionalAttrs osConfig.services.xray.enable {
  proxy-xray = {
    type = "custom/systemd-service:service";
    glyph = "network";
    service = "xray.service";
  };
}
