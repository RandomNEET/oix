{ lib, opts, ... }:
let
  desktop = opts.desktop or "";
  exclude = [
    ""
    "shared"
  ];
  shouldImport = !(lib.elem desktop exclude) && (builtins.pathExists ./${desktop});
in
{
  imports = lib.optionals shouldImport [ ./${desktop} ];
}
