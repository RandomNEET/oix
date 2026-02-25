{
  lib,
  pkgs,
  opts,
  getExe,
  ...
}:
[
  { sh = "dbus-update-activation-environment --systemd --all"; }
  { sh = "wl-clipboard-history -t"; }
  { sh = "wl-paste --type text --watch cliphist store"; }
  { sh = "wl-paste --type image --watch cliphist store"; }
  { sh = "rm $XDG_CACHE_HOME/cliphist/db"; }
]
++ lib.optional (((opts.terminal or "") == "foot") && (opts.foot.server or false)) {
  sh = "${getExe pkgs.foot} --server";
}
