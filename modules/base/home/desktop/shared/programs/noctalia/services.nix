{ osConfig, lib }:
{
  audio = {
    enable_sounds = false;
  };
  battery = {
    warning_threshold = 20;
  };
  brightness = {
    enable_ddcutil = osConfig.base.display.ddcutil.enable;
  };
  calendar = {
    enabled = false;
  };
  idle = {
    behavior = {
      lock = {
        enabled = true;
        action = "lock";
        command = "noctalia:session lock";
        timeout = 600;
      };
      screen-off = {
        enabled = true;
        action = "screen_off";
        command = "noctalia:dpms-off";
        resume_command = "noctalia:dpms-on";
        timeout = 660;
      };
    };
  };
  location = {
    auto_locate = true;
  };
  nightlight = {
    enabled = false;
  };
  notification = {
    enable_daemon = true;
    blacklist = [ ];
    blacklist_allow_critical = true;
  };
  system = {
    monitor = {
      enabled = true;
      gpu_poll_seconds = if !(lib.strings.hasInfix "integrated" osConfig.base.gpu) then 5.0 else 0;
    };
  };
  weather = {
    enabled = true;
  };
}
