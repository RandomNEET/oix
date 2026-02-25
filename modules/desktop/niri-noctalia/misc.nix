{ opts, ... }:
{
  input = {
    touchpad = {
      tap = true;
      natural-scroll = true;
    };
  };

  outputs = opts.niri.settings.outputs or { };

  layout = {
    gaps = 10;
    background-color = "transparent";
    center-focused-column = "never";

    preset-column-widths = [
      { proportion = 1.0 / 3.0; }
      { proportion = 0.5; }
      { proportion = 2.0 / 3.0; }
    ];

    default-column-width = {
      proportion = 0.5;
    };

    focus-ring = {
      enable = false;
    };

    border = {
      enable = true;
      width = 2;
    };

    shadow = {
      enable = true;
      softness = 30;
      spread = 5;
      offset = {
        x = 0;
        y = 5;
      };
    };
  };

  overview = {
    zoom = 0.5;
    workspace-shadow = {
      enable = false;
    };
  };

  prefer-no-csd = true;

  hotkey-overlay = {
    skip-at-startup = true;
    hide-not-bound = true;
  };

  screenshot-path = "~/pic/screenshots/screenshot from %Y-%m-%d %H-%M-%S.png";

  debug = {
    honor-xdg-activation-with-invalid-serial = { };
  };
}
