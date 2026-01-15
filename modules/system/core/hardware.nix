{ opts, ... }:
let
  display = opts.display or [ ];
  hasExternalDisplay = builtins.any (d: d.external == true) display;
in
{
  hardware = {
    i2c.enable = hasExternalDisplay;
  };
}
