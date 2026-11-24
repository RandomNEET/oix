{ osConfig, lib }:
{
  order = [ "main" ];
  main = {
    enabled = true;
    margin_ends = 10;
    margin_edge = 10;
    capsule = false;
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
        id = "media";
        members = [
          "media"
          "audio_visualizer"
        ];
        radius = 8.0;
      }
      {
        id = "sysmon";
        members = [
          "cpu"
          "ram"
        ];
        radius = 8.0;
      }
      {
        id = "connection";
        members = [
          "network"
          "bluetooth"
        ]
        ++ lib.optional osConfig.services.dae.enable "proxy-dae"
        ++ lib.optional osConfig.services.xray.enable "proxy-xray";
        radius = 8.0;
      }
      {
        id = "services";
        members = [
          "output_volume"
          "brightness"
          "battery"
          "keyboard_layout"
        ];
        radius = 8.0;
      }
    ];
  };
}
