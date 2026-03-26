{
  lib,
  pkgs,
  opts,
  randomwallctl,
  getExe,
  ...
}:
[
  { sh = "nm-applet --indicator"; }
  { sh = "${randomwallctl} -r"; }
]
++ lib.optional (((opts ? terminal) && (opts.terminal == "foot")) && (opts.foot.server or false)) {
  sh = "${getExe pkgs.foot} --server";
}
