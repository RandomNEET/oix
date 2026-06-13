{ osConfig, lib }:
{
  audio = {
    enable_overdrive = false;
    enable_sounds = false;
    sound_volume = 0.5;
    volume_change_sound = "";
    notification_sound = "";
  };
  battery = {
    warning_threshold = 20;
  };
  brightness = {
    enable_ddcutil = osConfig.base.display.ddcutil.enable;
    ignore_mmids = [ ];
  };
  calendar = {
    enabled = false;
    refresh_minutes = 15;
  };
  idle = {
    pre_action_fade_seconds = 2.0;
    behavior = {
      lock = {
        enabled = true;
        timeout = 600;
        command = "noctalia:session lock";
      };
      screen-off = {
        enabled = true;
        timeout = 660;
        command = "noctalia:dpms-off";
        resume_command = "noctalia:dpms-on";
      };
    };
  };
  location = {
    auto_locate = true;
  };
  nightlight = {
    enabled = false;
    force = false;
    temperature_day = 6500;
    temperature_night = 4000;
  };
  notification = {
    enable_daemon = true;
    show_app_name = true;
    position = "top_right";
    layer = "top";
    scale = 1.0;
    background_opacity = 0.97;
    offset_x = 20;
    offset_y = 8;
    monitors = [ ];
    collapse_on_dismiss = true;
    blacklist = [ ];
    blacklist_allow_critical = true;
    allowed_urgencies = [ ];
  };
  system = {
    monitor = {
      enabled = true;
      cpu_poll_seconds = 2.0;
      gpu_poll_seconds = if !(lib.strings.hasInfix "integrated" osConfig.base.gpu) then 5.0 else 0;
      memory_poll_seconds = 2.0;
      network_poll_seconds = 3.0;
      disk_poll_seconds = 10.0;

      cpu_usage_activity_threshold = 50;
      cpu_usage_critical_threshold = 90;
      cpu_temp_activity_threshold = 60;
      cpu_temp_critical_threshold = 85;
      gpu_temp_activity_threshold = 60;
      gpu_temp_critical_threshold = 85;
      gpu_usage_activity_threshold = 50;
      gpu_usage_critical_threshold = 95;
      gpu_vram_activity_threshold = 50;
      gpu_vram_critical_threshold = 90;
      ram_pct_activity_threshold = 60;
      ram_pct_critical_threshold = 90;
      swap_pct_activity_threshold = 20;
      swap_pct_critical_threshold = 80;
      disk_pct_activity_threshold = 80;
      disk_pct_critical_threshold = 95;
      net_rx_activity_threshold = 1;
      net_rx_critical_threshold = 50;
      net_tx_activity_threshold = 1;
      net_tx_critical_threshold = 50;
    };
  };
  weather = {
    enabled = true;
    refresh_minutes = 30;
    unit = "metric";
    effects = true;
  };
}
