{ lib, opts, ... }:
let
  themes = opts.themes or [ ];
  hasThemes = themes != [ ];
  defaultTheme = if themes != [ ] then builtins.head themes else "";
in
{
  imports = lib.optional (
    hasThemes && (builtins.pathExists ./${defaultTheme}.nix)
  ) ./${defaultTheme}.nix;
}
