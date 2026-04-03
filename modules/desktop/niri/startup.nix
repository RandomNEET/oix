{
  lib,
  pkgs,
  opts,
  getExe,
  ...
}:
[
  { sh = "noctalia-shell"; }
]
++ lib.optional (((opts ? terminal) && (opts.terminal == "foot")) && (opts.foot.server or false)) {
  sh = "${getExe pkgs.foot} --server";
}
