{ lib, opts, ... }:
{
  imports = lib.optional (
    ((opts.theme or "") != "") && (builtins.pathExists ./${opts.theme}.nix)
  ) ./${opts.theme}.nix;
}
