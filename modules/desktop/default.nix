{ lib, opts, ... }:
let
  desktop = opts.desktop or "";
  exclude = [
    ""
    "themes"
    "shared"
  ];
  shouldImport = !(lib.elem desktop exclude) && (builtins.pathExists ./${desktop});
in
{
  imports = [ ./themes ] ++ lib.optional shouldImport ./${desktop};
}
