{
  input = {
    keyboard = {
      repeat-delay = 300;
    };
    touchpad = {
      tap = { };
      natural-scroll = { };
    };
  };

  prefer-no-csd = { };

  screenshot-path = "~/pic/screenshots/screenshot-%Y-%m-%d-%H:%M:%S.png";

  cursor = {
    hide-after-inactive-ms = 10000;
  };

  overview = {
    zoom = 0.5;
    workspace-shadow = {
      off = { };
    };
  };

  hotkey-overlay = {
    skip-at-startup = { };
    hide-not-bound = { };
  };

  debug = {
    honor-xdg-activation-with-invalid-serial = { };
  };
}
