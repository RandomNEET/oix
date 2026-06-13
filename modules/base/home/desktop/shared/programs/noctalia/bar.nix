{ osConfig, lib }:
{
  order = [ "main" ];

  main = {
    position = "top";
    enabled = true;
    auto_hide = false;
    reserve_space = true;
    layer = "top";

    thickness = 34;
    background_opacity = 1.0;
    border = "outline";
    border_width = 0.0;
    shadow = true;
    contact_shadow = false;
    panel_overlap = 1;
    radius = 12;
    radius_top_left = 12;
    radius_top_right = 12;
    radius_bottom_left = 12;
    radius_bottom_right = 12;
    margin_ends = 10;
    margin_edge = 10;
    padding = 14;
    widget_spacing = 6;
    scale = 1.0;
    font_weight = "regular";

    capsule = false;
    capsule_fill = "surface_variant";
    capsule_radius = 8.0;
    capsule_opacity = 1.0;

    start = [
      "workspaces"
      "taskbar"
      "group:media"
    ];
    center = [ "clock" ];
    end = [
      "group:sysmon"
      "group:connection"
      "group:services"
      "tray"
      "notifications"
      "control-center"
    ];
    capsule_group = [
      {
        fill = "surface_variant";
        id = "media";
        members = [
          "media"
          "audio_visualizer"
        ];
        opacity = 1.0;
        padding = 6.0;
        radius = 8.0;
      }
      {
        fill = "surface_variant";
        id = "sysmon";
        members = [
          "cpu"
          "ram"
        ];
        opacity = 1.0;
        padding = 6.0;
        radius = 8.0;
      }
      {
        fill = "surface_variant";
        id = "connection";
        members = [
          "network"
          "bluetooth"
        ]
        ++ lib.optional (osConfig.services.dae.enable || osConfig.services.xray.enable) "proxy";
        opacity = 1.0;
        padding = 6.0;
        radius = 8.0;
      }
      {
        fill = "surface_variant";
        id = "services";
        members = [
          "volume"
          "brightness"
          "battery"
        ];
        opacity = 1.0;
        padding = 6.0;
        radius = 8.0;
      }
    ];
  };
}
