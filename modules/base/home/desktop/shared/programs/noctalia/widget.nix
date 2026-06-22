{ osConfig, lib }:
let
  inherit (lib) optionalAttrs;
in
{
  workspaces = {
    display = "id";
    minimal = false;
    max_label_chars = 1;
    pill_scale = 1.0;
    focused_color = "primary";
    occupied_color = "secondary";
    empty_color = "secondary";
    labels_only_when_occupied = false;
    hide_when_empty = true;
  };
  taskbar = {
    group_by_workspace = false;
    show_all_outputs = false;
    only_active_workspace = true;
    show_workspace_label = true;
    workspace_label_placement = "corner";
    hide_empty_workspaces = false;
    workspace_group_capsule = true;
    group_single_icon_per_app = false;
    show_active_indicator = true;
    active_opacity = 1.0;
    inactive_opacity = 1.0;
    focused_color = "primary";
    occupied_color = "secondary";
    empty_color = "secondary";
  };
  media = {
    album_art_only = false;
    min_length = 80;
    max_length = 220;
    art_size = 16;
    title_scroll = "always";
    hide_when_no_media = true;
  };
  audio_visualizer = {
    width = 56;
    bands = 16;
    mirrored = true;
    centered = true;
    show_when_idle = false;
    color_1 = "primary";
    color_2 = "primary";
  };
  clock = {
    format = "{:%a %b %e %H:%M}";
    vertical_format = "{:%m %d - %H %M}";
    tooltip_format = "{:%Y-%m-%d %H:%M:%S}";
  };
  cpu = {
    stat = "cpu_usage";
    type = "sysmon";
  };
  ram = {
    stat = "ram_used";
    type = "sysmon";
  };
  network = {
    show_label = true;
  };
  bluetooth = {
    show_label = false;
  };
  brightness = {
    scroll_step = 5;
    show_label = true;
  };
  volume = {
    device = "output";
    scroll_step = 5;
    show_label = true;
  };
  battery = {
    display_mode = "glyph";
    show_label = true;
    device = "auto";
    warning_threshold = 20;
    warning_color = "error";
  };
  tray = {
    hidden = [ ];
    pinned = [ ];
    match_adjacent_spacing = false;
    drawer = false;
    drawer_columns = 3;
    capsule = true;
  };
  notifications = {
    hide_when_no_unread = false;
  };
  control-center = {
    glyph = "chevron-down";
  };
}
// optionalAttrs osConfig.services.dae.enable {
  proxy = {
    command = "sh -c 'if systemctl is-active --quiet dae.service; then pkexec systemctl stop dae.service && notify-send -u low dae.service Stopped; else pkexec systemctl start dae.service && notify-send -u low dae.service Started; fi'";
    glyph = "network";
    tooltip = "Toggle dae.service";
    type = "custom_button";
  };
}
// optionalAttrs osConfig.services.xray.enable {
  proxy = {
    command = "sh -c 'if systemctl is-active --quiet xray.service; then pkexec systemctl stop xray.service && notify-send -u low xray.service Stopped; else pkexec systemctl start xray.service && notify-send -u low xray.service Started; fi'";
    glyph = "network";
    tooltip = "Toggle xray.service";
    type = "custom_button";
  };
}
