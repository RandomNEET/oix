{
  keybinds = {
    validate = [
      "return"
      "enter"
    ];
    cancel = [ "escape" ];
    left = [
      "ctrl+h"
      "left"
    ];
    right = [
      "ctrl+l"
      "right"
    ];
    up = [
      "ctrl+k"
      "up"
    ];
    down = [
      "ctrl+j"
      "down"
    ];
  };

  lockscreen = {
    enabled = true;
    blurred_desktop = false;
    blur_intensity = 0.5;
    tint_intensity = 0.3;
    wallpaper = "";
  };

  osd = {
    position = "top_center";
    orientation = "horizontal";
    scale = 1.0;
    monitors = [ ];
    kinds = {
      volume = true;
      volume_output = true;
      volume_input = true;
      brightness = true;
      wifi = true;
      bluetooth = true;
      power_profile = true;
      caffeine = true;
      dnd = true;
      lock_keys = true;
      keyboard_layout = true;
    };
  };

  desktop_widgets = {
    enabled = false;
  };
}
