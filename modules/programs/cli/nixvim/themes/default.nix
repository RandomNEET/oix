{ lib, opts, ... }:
{
  imports = lib.optional (
    ((opts.theme or "") != "") && (builtins.pathExists ./${opts.theme})
  ) ./${opts.theme};
}
